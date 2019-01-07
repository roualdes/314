---
interact_link: content/normal/means.ipynb
title: 'Estimating Means'
prev_page:
  url: /normal/introduction
  title: 'Normal Distribution'
next_page:
  url: /bootstrap/introduction
  title: 'Bootstrap'
comment: "***PROGRAMMATICALLY GENERATED, DO NOT EDIT. SEE ORIGINAL FILES IN /content***"
---

# Estimating Means

The first formal model in these notes happened so fast, you might have missed it.  By assuming $X_n \sim_{iid} \text{Bernoulli}(p)$, we created a single model.  This one statistical model assumed the Bernoulli distribution.  Our data consisted of multiple independent observations from the identical distribution (iid), a Bernoulli distribution with unknown population parameter $p$.

In this section, we change the assumed distribution to the Normal distribution.  Because the support for the Normal distribution is all real numbers, this distribution applies to data that could potentially take on any value in the real line.  We complete the section by rehearsing our use of the likelihood function as it applies to Normal data.  When, out in the real world on your own, if don't know what model to apply, assume normality.  

## Density Plot

It's common to assume any single numerical variable data follows a Normal distribution, $ Y_n \sim \text{Normal}(\mu, \sigma)$ for $n = 1, 2, \ldots, N$.  Note that we will call this a formal model although I understand that it is difficult to separate the ideas of distribution and model at this point.  For now, let's push forward and begin as we ought to begin any analysis, plot the data.



{:.input_area}
```R
library(ggplot2)
```


Let's return to our dataset about the Order Carnivora.  Consider the variable `BW`, which records birth weight in grams.  These are **numeric** data and it's reasonable to assume the data came from a **continuous** random variable, because grams can theoretically take on any positive value in a reasonable range for birth weights from the Order Carnivora.  To plot these data we'll use a **density plot**.  A common alternative plot is a histogram.



{:.input_area}
```R
carnivora <- read.csv("~/website/app/public/data/carnivora.csv")
ggplot(carnivora) + geom_density(aes(BW))
```





{:.output .output_png}
![png](../images/normal/means_6_1.png)



The above plot tells us that the majority of our data consist of observations below $500$ grams with a few observations showing up sporadically above $500$.  How many observations are above $500$ is not immediately clear, so let's see if we can modify the plot above to help us visualize all of the data.



{:.input_area}
```R
ggplot(carnivora) + 
    geom_density(aes(BW)) +
    geom_rug(aes(BW))
```





{:.output .output_png}
![png](../images/normal/means_8_1.png)



## Properties of the Normal Distribution

If $Y \sim \text{Normal}(\mu, \sigma)$, then one can **standardize** the random variable $Y$ by subtracting off the mean $\mu$ and scaling by the standard deviation $\sigma$,

$$ Z = \frac{Y - \mu}{\sigma} \sim \text{Normal}(0, 1). $$

This linear transformation of a random variable that follows a normal distribution is so common, that the random variable $Z$ has a special name.  A random variable that follows the $\text{Normal}(0, 1)$ distribution is called **standard Normal**; $Z$ follows a standard Normal distribution with mean $\mu = 0$ and variance $\sigma = 1$.

The probability density function of the $\text{Normal}(\mu, \sigma)$ distribution is

$$ \text{normal}(x | \mu, \sigma) = (2\pi\sigma^2)^{-1/2} \exp{\left( \frac{-(x - \mu)^2}{2\sigma^2} \right) }. $$

A plot of the standard Normal probability density function is displayed below.  Try to change the code to help you better understand that the $\text{Normal}(\mu, \sigma)$ distribution indexes an uncountable number of distributions via $\mu$ and $\sigma$.  For each specific choice of $(\mu, \sigma)$, think of it as an instantiation of a new random variable.



{:.input_area}
```R
df <- data.frame(x = seq(-4, 4, length.out=101))
ggplot(df, aes(x)) + stat_function(fun = dnorm, args=list(mean=0, sd=1))
```





{:.output .output_png}
![png](../images/normal/means_11_1.png)



## Likelihood

### Example

To estimate the population mean birth weight of animals from the Order Carnivora $\mu$, we'll assume a Normal distribution, $Y_n \sim_{iid} \text{Normal}(\mu, \sigma)$.  Find the MLE of $\mu$ and then $\sigma$.

### Example

Find the MLE of $(\mu, \sigma)$ using a computer.

## Assumed Normality

Notice from the plot above of birth weights from the Order Carnivora, the data don't obviously come from a Normal distribution, and yet we modeled these data with a Normal distribution.  Such an assumption doesn't offend nearly any statistician, and yet it's almost offensive that no statistician is bothered by this.  In this subsection, we'll explore why statisticians are often happy to assume normality.

Statisticians are not often bothered by assuming Normal data, because they are trained to not think about data statically.  The randomness of data, despite the data appearing to be fixed quantities, comes from imagining that the process that produced these data could be repeated (even if it can't).  In the case of a random sample of animals from the Order Carnivora, this would mean that you could (but wouldn't) randomly sample a new set of data from the same population of animals from the Order Carnivora.

Recall that earlier in these notes, we already saw this idea.  Our operational definition of probability is the limitting relative frequency of repeating the process an infinite number of times.  We are now expanding on this idea to imagine that an entire new dataset comes from each iteration.

Statisticians recognize that collecting new data is unlikely to happen, but based on our operational definition of probability, this theoretical resampling is just the natural, logical extension.  Since each new dataset comes from the same population, we'd assume the Normal distribution for each new dataset.  Based on the model $Y_n \sim \text{Normal}(\mu, \sigma)$, the likelihood dictates that we use the sample mean to estimate $\mu$.  The punchline to all of this is that statisticians can prove mathematically the shape of the multiple estimates of $\mu$ that would come about based on this infinite resampling.

Just like we can use a computer to approximate the probability a coin flip turning up heads to be $1/2$, we can simulate the shape of multiple esimates of $\mu$ from a population of animals from the Order Carnivora.  Let's look at the code and a plot, and then I'll explain what's going on.



{:.input_area}
```R
library(dplyr)
d <- carnivora %>%
    select(BW) %>%
    na.omit %>%
    pull(BW) # use dplyr to remove NAs and retreive vector of interest

N <- length(d) # sample size
R <- 1001 # number of resampled datasets
mus <- rep(NA, R) # preallocate!

for (r in seq_len(R)) {
    idx <- sample(N, N, replace=TRUE) # resample by index
    mus[r] <- mean(d[idx]) # index a vector with a vector and calculate mean
}

ggplot(data.frame(mu = mus)) + 
    geom_density(aes(mu)) + # sampling distribution of multiple estimates of mu
    geom_rug(aes(mu)) +
    stat_function(fun=dnorm, 
                  args=list(mean=mean(d), sd=sd(d)/sqrt(N)),
                  color="orange")
```





{:.output .output_png}
![png](../images/normal/means_17_1.png)



Let's explain the code above in English, before we dive into the details of what just happened statistcally.  We are interested in birth weights from animals of the Order Carnivora, but we are not interested in missing values, encoded as `NA`s in R.  We use the library `dplyr` to `select` only specific variables we are currently interested in, omit the `NA`s, and then `pull` out the vector of data we want from the data frame.

The next paragraph (if you will) of code, stores the sample size and the number of resamples to take.  The number of resamples is analogous to how many coin flips you want to simulate.  In this case, `R` is specifically how many new data sets you want to simulate.  Next, we preallocate a chunk of memory to hold our `R` estimates of $\mu$.  Preallocation is necessary in statically typed languages and an incredibly good idea in any language that allows it.

The for loop iterates over a vector of integers of length `R`.  In each iteration, we randomly sample integers that correspond the index of specific observations in our vector of data.  Sampling by index seems like a pain right now, but it is more memory efficient and we'll learn in the future that is the more robust solution.  Each loop creates a new vector of indices `idx`, that we use to index our original vector of data and then calculate the sample mean.  By the end of the for loop, we have `R` estimates of $\mu$.

The plot displays a density plot of the multiple estimates of $\mu$.  This density plot (in blue) graphically represents an estimate of the **sampling distribution** of the sample mean.  The sampling distribution of an estimator is the theoretical distribution for the collection of statistics one would obtain if they infinitely resampled from the population of interest.  In the scenario above, we resampled and calculated the statistic the sample mean.  Because we resampled only `R` times, this is an approximation of the sampling distribution for the sample mean.

Pay particular attention to the fact that our original data is not Normal, but the collection of multiple estimates of $\mu$ are in fact nearly Normal.  This phenomenon, named the **Central Limit Theorem** is a classic result of mathematical statistics.  For an arbitrary population distribution with finite variance, the sampling distribution for the sample mean will be approximately $\text{Normal}(\mu, \sigma/\sqrt{N})$.  Notice the square root of the sample size in the denominator of the standard deviation.  This says that as the sample size tends to infinity, the standard deviation of the sampling distribution will collapse on the true population mean $\mu$; when you collect all the individuals from the population mean, you will know the population mean, no more estimating.  The plot above also contains the Central Limit Theorem approximation (in orange) to the sampling distribution of the sample mean.

## Sampling Distributions

Recall that a statistic is any function calculated from a set of random variables (data).  By applying the logic above, all statistics have sampling distributions.  These sampling distributions come about by imagining infinitely resampling the same population and calculating the same statistic on each new sample.  

It takes a minute to accept this fact.  You need to keep in mind that each statistic, calculated from what you once thought was a static dataset, is now to be thought of as a single random variable.  Each statistic is a function applied to random variables.  Because the arguments to the function are random variables, the statistic is a random variable.  And, random variables follow distributions.

Even after you accept that every statistic should be thought of as a random variable, it still doesn't quite help you imagine the sampling distribution for that statistic.  It's hard to imagine sampling distributions for statistics, because we don't know their shape.  The key points that you should keep in mind are that sampling distributions

1. exist,
2. are different for each statistic, and
3. are easiest to remember when you've grasped how they come about; data are not static.

## Central Limit Theorem

A more formal definition of the Central Limit Theorem goes like this.  Assume $X_n \sim_{iid} F(\theta)$ for $n = 1, \ldots, N$ where $\mathbb{E}(X) = \mu$ and $\mathbb{V}(X) = \sigma^2 < \infty$.  Let $\hat{\mu}$ denote the sample mean.  Then

$$ \hat{\mu}\stackrel{\cdot}{\sim} \text{Normal}\left(\mu, \frac{\mathbb{D}(X)}{\sqrt{N}} \right). $$

In English, we'd read the sampling distribution of the sample mean approaches a normal distribution with mean $\mu$ and standard deviation $\mathbb{D}(X)/\sqrt{N}$ as the sample size increases, so long as the population from which the independent data were sampled has finite variance.

There are a few important facts about the Central Limit Theorem above.  As stated above, the Central Limit Theorem

1. depends on unknown population parameters, $\mu$ and $\mathbb{D}(X)$,
2. is an approximation of the sampling distribution of the sample mean that depends on the sample size $N$, and
3. doesn't tell us about other statistics than the sample mean.

Notice that I didn't claim that the finiteness of the variance of the population as an important fact.  This assumption is generally a reasonable assumption that most applied statisticians are willing to accept.

In most introductory statistics courses, the majority of the course material is based around the Central Limit Theorem.  The Central Limit Theorem is a mathematical theorem, with it's own assumptions, but by focusing on it, a course is making assumptions about the student's future use of statistics.  Using only statistics that follow the CLT limits students application of statistics.  On the other hand, statisticians maintain their jobs by showing that statistics other than the sample mean follow the Central Limit Theorem, and there's been no shortage of papers on this topic.
