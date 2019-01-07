---
title: 'Summary'
prev_page:
  url: /bernoulli/proportions
  title: 'Estimating Proportions'
next_page:
  url: /distributions/introduction
  title: 'Distributions'
comment: "***PROGRAMMATICALLY GENERATED, DO NOT EDIT. SEE ORIGINAL FILES IN /content***"
---
# Summary

Statistics studies how to estimate population parameters from random
samples of data.  As an applied discipline, we need to maintain the
specifics of our context to enable proper interpretation.  As a
mathematical discipline, we need to keep track of all the different
named functions and their roles.

In statistics, populations are abstracted to different named
distribution.  Each distribution produces random variables that
constitute a sample.  With random variables in hand, we establish
means to estimate parameters that describe the population of interest.
You should imagine that a parameter instantiates a specific
probability density function.  In this course, we use the likelihood
function to estimate the unknown parameter that instatiates
function that describes our target population.

Key concepts/words:

* the goal of statistics
* **population**
* **sample**
* **categorical variable**
    * a variable in a dataset that takes on not-mathable values
* **levels**
    * values that a categorical variable could take on
* **individual/observation**
    * a noun in the population of interest, not necessarily people
* **random variable**
    * a function from an event to a numerical value, e.g. $X(\\{Caniformia\\}) = 1$.
* **discrete random variable**
    * a random variable that only takes on a countable set of values
* **dataframe**
    * a two dimensional data structure in the programming language R
      in which each row represents a new observation and each column
      represents a new variable
* **Bernoullid distribution**
    * a named random variable used to binary outcomes; $1$ usually
      denotes level of interest
* **probability density function**
    * a function indexed by parameter(s) of interest, the shape of
      which theoretically describes the process of interest
* **statistic**
    * any function of data
* **proportion**
    * AKA a mean, when applied to numerically encoded binary
      categorical data; unfortunately thought of as $successes / trials$.
* **parameter**
    * a characteristic of a population, abstracted to non-data
      arguments of probability density functions.
* **independent and identically distributed**
    * a description of data that suggests the data were randomly
      sampled (independent $\Rightarrow$ no two data points
      intentionally share anything in common, except) that they come
      from the same population (identically distributed).
* likelihood
* **maximum likelihood estimator**
