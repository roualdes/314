---
redirect_from:
  - "/normal-models/k-means"
interact_link: content/normal_models/k_means.ipynb
kernel_name: python3
has_widgets: false
title: 'k Means'
prev_page:
  url: /normal_models/two_means
  title: 'Two Means'
next_page:
  url: /normal_models/multiple_linear_reg
  title: 'Multiple Linear Regression'
comment: "***PROGRAMMATICALLY GENERATED, DO NOT EDIT. SEE ORIGINAL FILES IN /content***"
---

# $k$ Means

This section is the immediate extension from two means to $k$ means. 

The name ANOVA is sometimes used in this setting. ANOVA stands for analysis of analysis of variance, but should be more literally translated to comparing $k$ levels' means.  The reason behind the name ANOVA is that often, but not in this class, the variation amongst the groups compared to variation within the groups gives a reasonable decision rule for determinging when means by level are different.

We continue to work with the dataset $\texttt{carnivora}$.  Now we'll estimate a mean for $k = 4$ of the levels of the categorical variable $\texttt{Family}$: Canidae, Felidae, Mustelidae, and Viverridae. For the body weight data, $\texttt{SW}$, we assume

$$ Y_1, \ldots, Y_N \sim_{iid} \text{Normal}(\mu, \sigma^2) \\
\mu = \beta_0 + \beta_1 * Felidae + \beta_2 * Mustelidae + \beta_3 * Viverridae.$$

Let's plot our data and add the mean as a new layer, now that we're getting good at plotting.  The code below first carefully removes missing data and filters our dataset down to the levels of interest.

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
```
</div>

</div>

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
carnivora = pd.read_csv("https://raw.githubusercontent.com/roualdes/data/master/carnivora.csv")
carn = carnivora[carnivora['Family'].isin(["Canidae", "Felidae", "Mustelidae", "Viverridae"])]
```
</div>

</div>

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
for i, (name, gdf) in enumerate(carn.groupby("Family")):
    y = gdf['SW']
    bp.jitter(np.repeat(i, y.size), y, jitter_y=0)
    bp.point(np.asarray([i]), y.mean(), color=bp.cat_color[1], size=1.5)
    
families = np.unique(carn['Family'])
bp.xticks(range(len(families)), labels=families, size=14)
bp.labels(x='Family', y='Body weight (kg)', size=18)
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
<matplotlib.axes._subplots.AxesSubplot at 0x119b4eb70>
```


</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

{:.output_png}
![png](../images/normal_models/k_means_3_1.png)

</div>
</div>
</div>

From the plot above, it seems like Felidae has the greatest mean weight, but it also seems like there is the most variation in Felidae.

### Example
Adapt the code above, along with the violin plot code from the two means section to make a violin plot for the four families above.

Code to fit our model above looks quite similar to our previous efforts in Sections Simple Linear Regression and Two Means.

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
def ll(beta, yX):
    y = yX[:, 0]
    X = yX[:, -4:]
    yhat = np.full(y.shape, np.nan)
    for r in range(X.shape[0]):
        yhat[r] = np.sum(beta * X[r,:])
    d = y - yhat
    return np.sum(d * d)

pX = patsy.dmatrix("~ C(Family)", data=carn)
yX = np.c_[carn["SW"], np.asarray(pX)]

beta = minimize(ll, normal.rvs(loc=10, size=4), args=(yX))["x"]
```
</div>

</div>

The same trick is taking place in our model.  The "intercept" is really the first level's mean, Canidae.  Each coefficient after that is a level-specific offset relative to Canidae's mean.  To find, say, Mustelidae's mean, you have to add $\hat{\beta}_0$ to $\hat{\beta}_2$.

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
np.round(beta[0] + beta[2], 3)
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
4.596
```


</div>
</div>
</div>

These estimates are still no different than group means.  Don't be discouraged, we are building to more complex models than group means.  Nonetheless, here's the empirical evidence.

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
(carn
 .groupby("Family")
 ["SW"]
 .agg("mean"))
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
Family
Canidae        9.511111
Felidae       36.458947
Mustelidae     4.595667
Viverridae     2.811250
Name: SW, dtype: float64
```


</div>
</div>
</div>

Quantifying uncertainty in our estimates is carried out with the bootstrap method.

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
N = carn['SW'].size
R = 999
betas = np.full((R, 4), np.nan)

for r in range(R):
    idx = np.random.choice(N, N)
    betas[r, :] = minimize(ll, normal.rvs(size=4), args=(yX[idx, :]))["x"]
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
axs = bp.subplots(1, 4)

ylab = lambda i: "Density" if i < 1 else ""
xlab = lambda i: f"$\\beta_{ {i} }$"
for a in range(len(axs)):
    bp.current_axis(axs[a])
    bp.density(betas[:, a])
    bp.percentile_h(betas[:, a], y=0)
    bp.rug(beta_p[:, a])
    bp.labels(x=xlab(a), y=ylab(a), size=18)
    
bp.tight_layout()
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
<matplotlib.axes._subplots.AxesSubplot at 0x11eb6a9b0>
```


</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

{:.output_png}
![png](../images/normal_models/k_means_13_1.png)

</div>
</div>
</div>

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
beta_p
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
array([[ 6.99005835, 14.09121455, -7.75871771, -9.32626222],
       [12.17099575, 41.13387438, -1.93307932, -4.08192669]])
```


</div>
</div>
</div>
