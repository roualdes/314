---
interact_link: content/bootstrap.ipynb
kernel_name: python3
has_widgets: false
title: 'Bootstrap'
prev_page:
  url: /normal
  title: 'Normal Distribution'
next_page:
  url: /normal_linear_models/introduction
  title: 'Normal Linear Models'
comment: "***PROGRAMMATICALLY GENERATED, DO NOT EDIT. SEE ORIGINAL FILES IN /content***"
---


# Bootstrap

## Introduction

In this course, we will rely on a method called the Bootstrap to approximate the sampling distribution of our statistics, insted of relying so directly on the Central Limit Theorem.  The name bootstrap shows up a lot these days, and I'm positive you have used this word to describe something different than what we'll talk about here.  Our Bootstrap has nothing to do with compilers nor CSS libraries.  

After estimating population parameters, a natural next question is, how certain are we in our estimate?  By approximating sampling distributions, the (statistical) Bootstrap will be our primary means of quantifying uncertainty in our estimates.  Such quantifications will primarily come in the form of confidence intervals.

## Sampling Distributions

The Bootstrap is a method to approximate the sampling distribution of an arbitrary statistic.  The sampling distribution of a statistic is to be thought of as the collection of statistics you'd have if you repeatedly resampled the population and calculated the statistic of interest on each new sample.  From this collection of resampled statistics we can estimate standard deviation of our estimator.

The plot below attempts to visualize this idea, albeit for a finite number of resamples `R`.  Different from last time we saw a visualization of the sampling distribution, this time we have no data.  By sampling from the (assumed) population, instead of from our original sample, our code is truer to the theory of sampling distributions, although further away from applied statistics.  Compare the code below to the example found in the Section [Normal Distribution](/normal/means#assumed-normality) to see what the difference between resampling from data and resampling from an assumed population looks like in terms of code.



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
import numpy as np
import pandas as pd
import bplot as bp
from scipy.stats import norm as normal

bp.LaTeX()
bp.dpi(300)

```
</div>

</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
R = 1001
N = 99
mus = np.full((R,), np.nan)

for r in range(R):
    mus[r] = np.random.gamma(2, 1/2, N).mean() # sample directly from Gamma(2, 2)


```
</div>

</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
bp.density(mus)
bp.rug(mus)
bp.labels(x='$\mu$', y='Density', size=18)

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
<matplotlib.axes._subplots.AxesSubplot at 0x11c4c8f98>
```


</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

{:.output_png}
![png](images/bootstrap_3_1.png)

</div>
</div>
</div>



The plot above represents a finite approximation to the sampling distribution of the sample mean coming from a $\text{Gamma}(2, 2)$ population. Despite the fact that a $\text{Gamma}(2, 2)$ probability density function is right skewed, we see that the sampling distribution is shaped like the probability density function for a Normal distribution, centered at $1$ with standard deviation $\mathbb{D}(X)/\sqrt{N} = \left(1/\sqrt{2}\right) / \sqrt{99}$.  The normalization of the sample means, each itself from the Gamma distribution, is due to the Central Limit Theorem.



## Percentiles



Another informative attribute of random variables is the **percentile**.  The $p$% percentile $\pi_p$ puts $p$% of the area under random variable's probability density function to the left of $\pi_p$.  A picture will help.  Consider a standrd normal distribution, where $\pi_{.84} \approx 1$.  Further, $\pi_{0.5} = 0$ for the standard normal distribution since the $\text{Normal}(0, 1)$ distribution is centered at, and perfectly symmetric about, $0$.  The more common name for $pi_{0.5}$ is the median.



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
import matplotlib.pyplot as plt

```
</div>

</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
x = np.linspace(-4, 4, 101)
fx = normal.pdf(x)

bp.curve(x, fx)
bp.line_v(1, 0, normal.pdf(1))
bp.labels(x='x', y='Density', size=18)

plt.text(-1, 0.1, '$\sim 0.84$', size=16)
plt.text(1.05, 0.01, '$\sim 0.16$', size=16)
plt.text(1, -0.075, '$\pi_{.84}$', size=16)

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
Text(1, -0.075, '$\\pi_{.84}$')
```


</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

{:.output_png}
![png](images/bootstrap_8_1.png)

</div>
</div>
</div>



R will calculate these values for us with the following code.



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
print(normal.ppf(.84))
print(normal.ppf(0.5))

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
0.994457883209753
0.0
```
</div>
</div>
</div>



When working with data, instead of a probability density function, find a sample percentile  by first sorting the data into ascending order.  With sorted data, find the value, not necessarily within the dataset, that puts approximately $p$% of the data to the left of the value of interest.  Since R will more often than not do these calculations for us, we just need remember that R will **interpolate** between any two numbers in a dataset so as to best, in some sense, apply the definition of percentile to data.



## Uncertainty in Estimates



We are slowly changing our thinking about the sample mean.  Before this class, most people would think of the sample mean as a single quantity.  Now, we are to think of the sample mean as one of potentially many possible values we could get by resampling the population and performing the same calculation on each new sample.  Each new sample mean would provide a new estimate of the population, but none would be exactly right.  How can we account for the uncertainty in our estimates?

A **confidence interval** is the interval analalogue to the sample mean; a lower and upper bound, two numbers calculated from data used to estimate the population parameter of interest.  The word confidence suggests that we want this random interval to capture the parameter of interest with some sort of degree of accuracy under repeated sampling.

We next blend together the sampling distribution, as estimated by the Bootstrap, together with percentiles to build a confidence interval for a parameter.  Assume you are interested in the mean of the $\text{Gamma}(2, 2)$ distribution above.  Since we know the population parameters $\alpha = 2$ and $\beta = 2$, we could certainly do the math and calculate the mean by hand.  Instead, let's use $\alpha = 2$ and $\beta = 2$ to generate new data, but then pretend we don't know these parameters when calculating a confidence interval.  This will allow us to check our method's accuracy.

Above, we approximated the sampling distribution of the sample mean of a $\text{Gamma}(2, 2)$ distribution by repeatedly resampling from the assumed known population.  Let's take a step closer to applying the Bootstrap and pretend that we have only one sample of data from this $\text{Gamma}(2, 2)$ population.  Then we'll estimate the sampling distribution via Bootstrap. The vector of sample means, `mus`, allows us to estimate two percentiles, $\pi_{0.025}$ and $\pi_{0.975}$.  The estimated percentiles will form our $95$\% confidence interval.



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
R = 1001
N = 99
d = np.random.gamma(2, 1/2, N)
mus = np.full((R,), np.nan)

for r in range(R):
    idx = np.random.choice(N, N)
    mus[r] = d[idx].mean()
    
np.round(np.percentile(mus, [2.5, 97.5]), 2)

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
array([0.79, 1.03])
```


</div>
</div>
</div>



For me, the interval is $(0.94, 1.24)$. The Bootstrap is inherently a stochastic procedure, so if you rerun the code above you might get slightly different numbers.  Since $\mathbb{E}(X) = \frac{\alpha}{\beta} = 2/2 = 1$, we see that this interval is indeed reasonably accurate.    

Within the framework of the Bootstrap, the only way to increase accuracy is to increase the sample size.  The only way to stabilize the randomness seen by rerunning the code above, and due to the random sampling, is to increase `R`.  Try increasing both `N` and `R` to see the effects.  Pay attention to accuracy, how close the interval is to the true mean $1$, and to the precision, how many decimal places stay the same after each run.  Take care to separate the ideas of accuracy and precision in your mind.

To interpret this interval, we say: *we are $95$% confident that the true population mean is between $.8$ and $1.1$*.  You should memorize the structure of this phrase.  Notice that we used data to make a statement about the population parameter of interest.  This is the crux of statistics: identify a parameter of interest, collect data about it, estimate the parameter, and quantify the uncertainty in your estimate.

If we were to repeat this analysis an infinite number of times, $95$% of the intervals created would include the true population mean.  This is operational definition of the percent confidence.

Remarkably, this procedure guarantees that $95$% of all confidence intervals made will capture the true population mean.  To apply this procedure to real data, we would repeatedly resample, with replacement and with equal probability, from the original dataset.  Next we continue with the example about birth weights of animals from the Order Carnivora found in Section [Assumed Normality](/normal/means#assumed-normality).



### Example



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
carnivora = pd.read_csv("https://raw.githubusercontent.com/roualdes/data/master/carnivora.csv")
bw = carnivora["BW"].dropna()

```
</div>

</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
N = bw.size                 # sample size
R = 1001                    # number of resamples
mus = np.full((R,), np.nan) # this is called what?

for r in range(R):
    idx = np.random.choice(bw._index, N) # resample index
    mus[r] = bw[idx].mean()              # index a vector with a vector, mean
    
np.round(np.percentile(mus, [5, 95]), 2) # 90% confidence interval

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
array([182.31, 324.93])
```


</div>
</div>
</div>



We are $90$% confident that the population mean birth weight of animals from the Order Carnivora is between $179$ and $326$ grams.  Again, you might get slightly different numbers if you rerun the code above; increasing `R` should stabilize this issue, at the cost of increasing the computational cost.

