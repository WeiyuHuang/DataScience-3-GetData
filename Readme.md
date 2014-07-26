Readme
========================================================

This is the readme document for run_analysis.R script.

Copyright 2014, Weiyu Huang. All rights reserved. No part of this publication may be reproduced or transmitted in any form or by any means, electronic or mechanical, including photocopy, recording, or any information storage and retrieval system, without permission in writing from the author.

## Input, Output

Input: Sumsung data, stored in the ./data/ folder

Output: output.txt, generated in the ./processed/ folder

## Description of how the script works

### Merge the training set

First we read meansurement data, acticity data, and subject data into x, y, subject variables respectively, for both the training set and the test set. Then we add column names for the read data for future references. The column names for the measurementa data can be obtained from "features.txt". Finally, we add subject and activity data into the scope and merge the training and test sets.

### Extract mean() and std() info
First we highlight the indexes corresponding to features including mean() and std() using normal expressions. Subsetting the merged data yileds the data of our interest.

### Descriptive activity names
We want acticity names to be more descriptive (in labels rather than in numerics). This can be doen by create a new factor vector with levels read from "activity_labels.tet" and set it to $activity variable.

### Descriptive variable names
We want to make variable names more descriptive. This is achieved by making the column names of the data more descriptive by replacing abbreviations with longer yet easier-to-understand notations.

### Create a new dataset
Since we need a summary (in fact, averaging) for each measurement for each subject and each activity, we need a new id variable containing both subject and activity info. After creating such a variable, data melting and casting with mean can be applied to generate the desired average info. Spliting the id variable containing both subject and activity info back to two variables and save the data using write.table yileds the desired output.






