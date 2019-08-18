---
redirect_from:
  - "/normal-models/one-mean"
interact_link: content/normal_models/one_mean.ipynb
kernel_name: python3
has_widgets: false
title: 'One Mean'
prev_page:
  url: /normal_models/introduction
  title: 'Normal Linear Models'
next_page:
  url: /normal_models/simple_reg
  title: 'Simple Linear Regression'
comment: "***PROGRAMMATICALLY GENERATED, DO NOT EDIT. SEE ORIGINAL FILES IN /content***"
---


# One Mean

Consider a dataset about $N = 54$ cars sampled from the year $1993$.  Of interest is the (unknown population) mean miles per gallon, $\mu$.  We assume 

$$Y_1, \ldots, Y_N \sim_{iid} \text{Normal}(\mu, \sigma^2) \\ \mathbb{E}(Y) = \mu.$$

The parameter $\sigma$ might be of interest to some, but not us now.  By choosing this model we are implicitly assuming that $\mathbb{E}(Y) = \mu$, where $\mu$ is a constant function that does not depend on any other characteristics about the population of cars from $1993$.  

Assuming the mean $\mu$ is constant is an unrealistic assumption if you think too long about this problem.  Nevertheless, this is a common assumption because of its simplicity.  In situations where simplicity is what you want, assuming the mean $\mu$ is constant across all cars from $1993$ is fine.  On the other hand, such simplicity is not always desired.  More complex models that relate mean miles per gallon to, say, weight or the drivetrain type are explored in the following sections of this chapter.

The following code reads in the dataset, plots the $\texttt{mpgCity}$ data, and calculates an estimate of the population mean, $\hat{\mu}$ based on the observed MPG for each car.



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
import numpy as np
import pandas as pd
import bplot as bp
from scipy.optimize import minimize

bp.LaTeX()

```
</div>

</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
cars = pd.read_csv("https://raw.githubusercontent.com/roualdes/data/master/cars.csv")

```
</div>

</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
def ll(mu, y):
    d = y - mu
    return np.sum(d * d)

mu_hat = minimize(ll, 10, args=(cars['mpgCity']), method="BFGS")['x']

```
</div>

</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
bp.density(cars['mpgCity'])
bp.rug(mu_hat)

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
[<matplotlib.lines.Line2D at 0x120ae35c0>]
```


</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

{:.output_png}
![png](../images/normal_models/one_mean_4_1.png)

</div>
</div>
</div>



The estimate $\hat{\mu}$ is our best guess of the population mean city MPG for cars from $1993$.  What we don't yet have is any measure of uncertainty surrounding this best guess.  Though this number seems reasonable, it's possible this number could have shown up by pure chance.  We'll next produce a confidence interval for the true population mean city MPG for cars from $1993$.  

The following code uses the library $\texttt{boot}$ to perform the random sampling (uniformly and with replacement) from the original data.  The same strategy that's discussed in Chapter Bootstrap is used here.  Sampling will happen over the indices of our original data.  The function $\texttt{boot::boot}$ requires that we write a function that takes two arguments, the data to calculate our statistic of interest on and a vector of indices.  



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
R = 999
N = cars['mpgCity'].size
mus = np.full((R, 1), np.nan)

for r in range(R):
    idx = np.random.choice(N, N)
    mus[r] = minimize(ll, 10, args=(cars['mpgCity'][idx]), method="BFGS")['x']
    
mu_p = np.percentile(mus, [10, 90])

```
</div>

</div>



The standard conclusion from this goes as follows.  We are $90\%$ confident that the true population mean city MPG for cars from $1993$ is between $21.9$ and $24.8$.

Notice though this confidence interval carries with it a number of assumptions.  The same assumption from before is carried forward, that the true population mean does not vary by any other population characteristics.  Further, the bounds of the confidence interval are randomly produced.  If you re-run the code above, you'll likely get slightly different numbers.  So don't get too carried away with carrying decimal places, $2$ is a good general policy.



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
bp.density(mus)
bp.rug(mu_p, color='black')
bp.rug(np.percentile(mus, [50]))
bp.labels(x='Mean MPG city', y='Density', size=18)

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
<matplotlib.axes._subplots.AxesSubplot at 0x1258c62e8>
```


</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

{:.output_png}
![png](../images/normal_models/one_mean_8_1.png)

</div>
</div>
</div>



When interpreting the estimated mean, and the lower and upper bound of the confidence interval, it's important to remember that these statistics are referring to the population mean, not specific data points.  Specifically, it is **not** the case that $90\%$ of all observed data (within this sample nor any future sample) will fall within this interval.  

A strict interpretation of this interval says that $90\%$ of an infinite collection of confidence intervals, calculated by and your infinite number of friends, will contain the true population mean.  That is $90\%$ of these (hypothetical) confidence intervals will capture the true population mean.  This indeed suggests that $10\%$ of the hypothetical confidence intervals will not capture the true population mean.

This subtle difference highlights the difference between estimating a population mean, for which it is reasonable to assume a Normal distribution, and fitting a distribution (via its parameters) to a dataset.

