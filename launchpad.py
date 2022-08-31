#!/usr/bin/env python
# coding: utf-8

# In[16]:


import numpy as np
from tensorflow.keras.preprocessing import image
from tensorflow.keras.utils import load_img, img_to_array
from keras.models import load_model
import keras
from keras.utils import np_utils
from keras.datasets import cifar10
import tensorflow as tf
from tensorflow.keras import layers
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Dense, Flatten, Dropout
from tensorflow.keras.models import Sequential
from tensorflow.keras.optimizers import Adam
from pathlib import Path


# In[2]:


# Load CIFAR-10 Dataset
(x_train, y_train), (x_test, y_test) = cifar10.load_data()


# In[3]:


# Normalize the images
x_train = x_train.astype("float32")
x_test = x_test.astype("float32")
x_train = x_train/255
x_test = x_test/255

y_train = keras.utils.np_utils.to_categorical(y_train, 10)
y_test = keras.utils.np_utils.to_categorical(y_test, 10)


# In[4]:


# Neural Network Architecture
# enable multi-gpu
strategy = tf.distribute.MirroredStrategy()
print('Number of devices: {}'.format(strategy.num_replicas_in_sync))
with strategy.scope():
    model = Sequential()
    model.add(Conv2D(32, (3, 3), padding="same",
              activation="relu", input_shape=(32, 32, 3)))
    model.add(Conv2D(32, (3, 3), activation="relu"))
    model.add(MaxPooling2D(pool_size=(2, 2)))
    model.add(Dropout(0.25))

    model.add(Conv2D(64, (3, 3), padding="same", activation="relu"))
    model.add(Conv2D(64, (3, 3), padding="same", activation="relu"))
    model.add(MaxPooling2D(pool_size=(2, 2)))
    model.add(Dropout(0.25))

    model.add(Flatten())
    model.add(Dense(512, activation="relu"))
    model.add(Dropout(0.5))
    model.add(Dense(10, activation="softmax"))

    model.summary()


# In[5]:


# Start Training
model.compile(loss="categorical_crossentropy",
              optimizer="adam", metrics=["accuracy"])
model.fit(x_train, y_train, batch_size=32, epochs=30,
          validation_data=(x_test, y_test), shuffle=True)


# In[9]:


# Save Model
model.save('/results/cifar.savedmodel')


# # Inference

# In[1]:


# load newly trained model
inference_model = load_model("/results/cifar_model2.h5")


# In[3]:


class_labels = ["Plane", "Car", "Bird", "Cat",
                "Deer", "Dog", "Frog", "Horse", "Boat", "Truck"]
img = image.load_img("/mnt/data/validation/frog.jpg", target_size=(32, 32))
image_to_test = image.img_to_array(img)/255
list_of_images = np.expand_dims(image_to_test, axis=0)
results = inference_model.predict(list_of_images)
single_result = results[0]
most_likely_result = int(np.argmax(single_result))

class_likelihood = single_result[most_likely_result]

class_label = class_labels[most_likely_result]
print("This image is a {} - Likelihood {:2f}".format(class_label, class_likelihood))
