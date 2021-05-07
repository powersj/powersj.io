---
title: "Big Data for Health Informatics (CSE 8803)"
date: 2016-05-15
tags: ["georgia tech"]
draft: false
aliases:
  - /post/cse8803-big-data-health-informatics/
---

In my final semester I was excited to take what would turn out a very, very difficult, yet highly satisfying course on big data tools using health data. I would rate this course as one of the most difficult courses I have ever taken.

## Deep-Dive Coursework

The course was front-loaded such that the first 8 weeks consisted of intense studies of the various big data tools. That work is detailed below:

### Python Pandas

The first assignment consisted of us taking large set of patient health data and manipulating it with the Python Pandas library. This project was to introduce us to some of the basic life cycle and problems data scientists run into when working with data:

* Manipulating large datasets that you cannot easily print out the entirety of
* Sanitizing your data
* Dealing with bad data
* Calculating statistics of the raw data
* Determining key features of the data
* Building training and test datasets
* Experimenting with a model parameters (e.g. k-means)
* Avoiding overfitting

The data utilized was real health data and our goal was to attempt to build models to predict patient mortality. It was an interesting project overall to take the medication, lab results, doctor visit data and determine patient mortality.

We also utilized Kaggle and held our own private competition to see who's model was built the best and avoided overfitting. It was extremely interesting to watch the leaderboard change drastically once the final dataset was provided and competition over.

### Apache Hadoop

Enter the Hadoop ecosystem! Finally, I get to play with the tools that I constantly hear about. This project was essentially a clone of the previous assignment, however it was utilizing Hadoop components.

**Hive** was used to first calculate various statistics. Hive is a NoSQL like key/value store running on top of HDFS. While this was not the most elegant mechanism, the point was to give us an opportunity to run SQL like queries in a Hive environment. This was significantly easier than the first assignment when trying to do this all in Pandas.

**Pig** was used to divide up pull out the specific data, complete feature construction, and then divide up into training and test sets. It was highly interesting to see how effortlessly Pig could be used to manipulate the data again compared to Pandas.

**Hadoop** was finally used to run the data and train multiple logistic regression classifiers. After building various map and reduce functions in Python we ran our data that we have just built to make predictions.

**HBase**, similar to a traditional SQL database, had a brief lab assignment where we went over the basic CRUD operations. However, HBase was not utilized for any assignment.

### Apache Spark & Scala

This is when things got a lot harder. Now that we were 'experts' on Hadoop, we turned our attention to the increasingly popular Apache Spark project. This assignment was built on top of Apache Spark and utilized Scala.

The first half was to take a new set of health data and build a supervised rule based phenotypes to determine our case, control, and other patients. **Spark SQL** was utilized to pull the data out that was necessary and place it in the Scala RDDs.

The second half required building an unsupervised phenotyping via clustering mechanism and the models were built using K-means and Gaussian mixture models. **Spark MLlib** was used to generate the models.

This whole assignment utilized Apache Spark and Scala, two things I had never used before. Scala, as a functional programming language, was something I had never utilized before. I struggled deeply with getting my mind around how to utilize the various functions and to do the data manipulations in an efficient manner.

### Spark GraphX

The final assignment would take similar data to the first two assignments and generate a patient graph. The graph vertices were either the patients or the various labs codes, visit codes, or drug codes. The edges connected the various patients with the specific labs, visits or drugs that they were related to.

**Spark GraphX** was the foundation for the graph that I built. I then built Scala code that would compute the similarity of the various patients to each other and determine the top 10 closest patients.

Finally, the page rank algorithm was used to compute for a specific patient vertex. This assignment really set in the concepts and techniques of Scala when manipulating large datasets.

## Project

For my project I took the Observational Health Data Sciences and Informatics (OHDSI) open source analytic tool's data queries and rewrote them to demonstrate Apache Spark's ability to more quickly process data in comparison to the use of traditional relational databases such as PostgreSQL.

The OHDSI Automated Characterization of Health Information at Large-scale Longitudinal Evidence Systems (ACHILLES) tool was built using R and is built to connect to a traditional database, like PostgreSQL.

My approach involved setting up the ACHILLES tool, generation and importing data into PostgreSQL, benchmarking the over 170 analytics that are generated, and then find the longest running queries to build an Apache Spark + Scala application around them.

You can check out a video of my results on [YouTube](https://www.youtube.com/watch?v=k5bl7VhgEmQ) and get the code and read the paper on [GitHub](https://github.com/powersj/spark4achilles).

## CITI Certification

Another aspect of this course was the need to get our CITI certifications in order to use the health data. Because this data was real we were trained on the various security and ethical handling of health data. This required over 20 hours of training.

Data used from MIMIC health care data set, which required CITI Biomedical (Group 1) and Social/Behavior (Group 2) Research and Investigators and Key Personnel certified and Health Information Privacy and Security (HIPS) for Biomedical Research certifications. My certifications are all valid till 2019.

## References

* [Apache Spark](https://spark.apache.org/)
* [Apache Hadoop](https://hadoop.apache.org/)
* [Python Pandas](http://pandas.pydata.org/)
* [OHDSI](http://www.ohdsi.org/)
* [ACHILLES](http://www.ohdsi.org/analytic-tools/achilles-for-data-characterization/)
* [CITI](https://www.citiprogram.org/)
