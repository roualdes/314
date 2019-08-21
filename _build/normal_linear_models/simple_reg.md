---
redirect_from:
  - "/normal-linear-models/simple-reg"
interact_link: content/normal_linear_models/simple_reg.ipynb
kernel_name: python3
has_widgets: false
title: 'Simple Linear Regression'
prev_page:
  url: /normal_linear_models/one_mean
  title: 'One Mean'
next_page:
  url: /normal_linear_models/two_means
  title: 'Two Means'
comment: "***PROGRAMMATICALLY GENERATED, DO NOT EDIT. SEE ORIGINAL FILES IN /content***"
---


# Simple Linear Regression

Let's continue with the cars data, but this time let's formally recognize that a car's weight might have some effect on city MPG.  Assume

$$ Y_1, \ldots, Y_N \sim_{iid} \text{Normal}(\mu, \sigma^2) \\
\mu = \beta_0 + \beta_1 * weight.$$

We again focus on the expected value, not $\sigma$, but we will start dropping the $\mathbb{E}(Y)$ notation because it quickly becomes cumbersome and needlessly repetitive.  Notice that this model implicitly states that the expected city MPG depends linearly on a car's weight.

The following code reads in the dataset, plots the $\texttt{mpgCity}$ variable against the $\texttt{weight}$ data, and calculates an estimate of the population mean dependent on the sampled cars' weights.  Here the estimated expected city MPG is formed by a linear combination of $\hat{\beta}_0, \hat{\beta}_1$ and $\texttt{weight}$.



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
import numpy as np
import pandas as pd
import bplot as bp
from scipy.optimize import minimize
from scipy.stats import norm as normal
import patsy

bp.LaTeX()
bp.dpi(300)

cars = pd.read_csv("https://raw.githubusercontent.com/roualdes/data/master/cars.csv")

```
</div>

</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
bp.scatter(cars['weight'], cars['mpgCity'])

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
<matplotlib.collections.PathCollection at 0x124a35b70>
```


</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

{:.output_png}
![png](../images/normal_linear_models/simple_reg_2_1.png)

</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
def ll(beta, yX):
    y = yX[:, 0]
    X = yX[:, -2:]
    yhat = np.full(y.shape, np.nan)
    for r in range(X.shape[0]):
        yhat[r] = np.sum(beta * X[r,:])
    d = y - yhat
    return np.sum(d * d)

pX = patsy.dmatrix("~ weight", data=cars)
yX = np.c_[cars['mpgCity'].values, np.asarray(pX)]

beta_hat = minimize(ll, normal.rvs(size=2), args=(yX))['x']

```
</div>

</div>



We write the estimated linear model as 

$$\hat{\mu} = \hat{\beta}_0 + \hat{\beta}_1*weight = 50.14 + -0.01*weight.$$

What's nice about this model is that we can easily interpret the parameters $\hat{\beta}_0 = 50.14$ and $\hat{\beta}_1 = -0.01$.  For instance, $\hat{\beta}_0$, better known as an intercept, is an estimate of (the population) city MPG for a car that weighs $0$ pounds.  While this doesn't make sense conceptually, this is the literal interpretation of the estimated intercept in the context of these data.  Notice that there's not data near $\text{weight} = 0$.  When this is the case, you can generally expect the intercept to not make much sense.

The slope, $\hat{\beta}_1$, describes the linear relationship between a car's weight and city MPG.  This estimate too is relatively easy to interpret in the context of these data.  For every 1 unit increase in a car's weight (a 1 pound increase), we estimate a $0.01$ decrease in the expected city MPG.  

Be careful to not overly interpret these estimates as describing a causal relationship.  Determining causal relationships from non-experimental data is no easy task, and we won't even try to broach this topic in this course.  Peter Norvig, Director of Research at Google, wrote an essay describing many of the difficulties of applied statistics practice surrounding observational data.  His essay [Warning Signs in Experimental Design and Interpretation](http://norvig.com/experiment-design.html) enumerates common warning signs for when a practioner of applied statistics might be misinterpreting their data.  For a more theoretical approach to determining causal relationships from data, see Judea Pearl's book [Causality](http://bayes.cs.ucla.edu/BOOK-2K/).



Just like before, the estimates $\hat{\beta}_0, \hat{\beta}_1$ are simply one set of estimates based on one random sample.  The values we produced could be due to pure random chance.  To better understand our uncertainty in these estimates, we will calculate confidence intervals.  We will let the function $\texttt{boot::boot}$ do the random sampling for us, and for that we need write a function that accepts our data and a vector of indices.



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
N = cars['mpgCity'].size
R = 999
betas = np.full((R, 2), np.nan)

for r in range(R):
    idx = np.random.choice(N, N)
    betas[r, :] = minimize(ll, normal.rvs(size=2), args=(yX[idx, :]))['x']

```
</div>

</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
beta_p = np.percentile(betas, [10, 90], axis=0)

```
</div>

</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
axs = bp.subplots(1, 2)

bp.current_axis(axs[0])
bp.density(betas[:, 0])
bp.percentile_h(betas[:, 0], y=0)
bp.rug(beta_p[:, 0])
bp.labels(x='Intercept', y='Density')

bp.current_axis(axs[1])
bp.density(betas[:, 1])
bp.percentile_h(betas[:, 1], y=0)
bp.rug(beta_p[:, 1])
bp.labels(x='Slope', y='Density')

bp.tight_layout()

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
<matplotlib.axes._subplots.AxesSubplot at 0x124fb9710>
```


</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

{:.output_png}
![png](../images/normal_linear_models/simple_reg_8_1.png)

</div>
</div>
</div>



The $90\%$ confidence intervals for $\beta_0$ and $\beta_1$ are



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
np.round(beta_p, 3)

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
array([[ 4.6007e+01, -1.0000e-02],
       [ 5.3851e+01, -8.0000e-03]])
```


</div>
</div>
</div>



Some classes will make a big deal about the slope estimate not including $0$.  There's no doubt such conclusions have some appeal.  However, this too often encourages binary thinking such as, "is the true population slope equal to zero or isn't it?"  When a statistic, known as p-value, is smaller than $0.05$ or a confidence interval excludes zero, the common phrase is, statistically significantly different from zero, as if zero or not are the only options.

Increasingly, statisticians are warning against such binary decision making; e.g. ["It’s time to talk about ditching statistical significance"](https://www.nature.com/articles/d41586-019-00874-8), ["Moving to a World Beyond 'p < 0.05'"](https://www.tandfonline.com/doi/full/10.1080/00031305.2019.1583913), or ["Scientists rise up against statistical significance"](https://www.nature.com/articles/d41586-019-00857-9).

In this class, we'll focus on predictions, understanding uncertainty in our predictions, and making decisions in the face of this uncertainty.

