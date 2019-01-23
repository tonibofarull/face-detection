# Face, eyes and gaze recognition

The project is structured in three parts:

* Data extraction
* Testing: K-fold cross-validation
* Real execution

## Data extraction

The data used can be found at the following links:

* [BioID](https://www.bioid.com/facedb) - Database to train face and eye SVMs.
* [Gaze](https://github.com/tonibofarull/face_recognition/blob/master/data/looking.txt) - Indicates for each image in the Database whether or not is looking at the camera. 

BioID provides images of person and the position of their eyes. 

With this information we have the subimages of (face/no-face), (eye/no-eyes) and the gaze of each photo.

## Real execution

The SVM are trained with the whole dataset and using a several sliding windows we try to find the one with the best score.

Example:

![alt text](https://github.com/tonibofarull/face_recognition/blob/master/test/res4.png)
