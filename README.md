# getting_cleaning_data_R

### What does the script do:
1. Creates a sub-folder ``/project_data``, downloads and unpacks there the required dataset
2. Makes a dataset from six given files: ``X_train.txt``, ``X_test.txt``, ``y_train.txt``, ``y_test.txt``, ``subject_train.txt`` and ``subject_test.txt``.
3. Labels all variables according to given codebook.
4. Extracts all ``mean`` and ``std`` variables from observations (_excluding ``meanFreq``_) into a dataset called ``df_meanAndStd``.
5. Generates tidy dataset that consists of the mean of each variable broken down by ``Subject`` and ``Activity``.
6. Writes this tidy dataset into ``average_subject_activity_dataset.txt`` file
