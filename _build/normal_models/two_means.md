---
redirect_from:
  - "/normal-models/two-means"
interact_link: content/normal_models/two_means.ipynb
kernel_name: ir
has_widgets: false
title: 'Two Means'
prev_page:
  url: /normal_models/simple_reg
  title: 'Simple Linear Regression'
next_page:
  url: /normal_models/k_means
  title: 'k Means'
comment: "***PROGRAMMATICALLY GENERATED, DO NOT EDIT. SEE ORIGINAL FILES IN /content***"
---

# Two Means

Simple linear regression attempts to explain a numerical variable based on a linear model.  The line is defined with respect to an x-axis numerical variable.  In this section, we will keep with a numerical variable on the y-axis, but we'll introduce a non-numeric variable on the x-axis.

Consider the dataset $\texttt{carnivora}$, which records a number of variables on the 112 animals from the Order Carnivora.  We are interested trying to predict $\texttt{SW}$, body weight (kg), using the **categorical variable** $\texttt{SuperFamily}$.  The **levels** of the categorical variable $\texttt{SuperFamily}$ are $\texttt{Caniformia}$ and $\texttt{Feliformia}$, which is to say that this dataset contains observations from animals from these two super families of the Order Carnivora.

The most common plot used to visualize the relationship between a numeric y-axis variable with a categorical variable (for now with two levels) is a boxplot.  A boxplot provides a visual representation of the $25$\%, $50$\%, and $75$\% quantiles.  There's a bit more to it, but we'll focus on a few more advanced plotting ideas than what is most common in practice.

Instead of a boxplot, we'll focus on two plots.  When there is a sufficiently small amount of data, we should make a scatter plot with the points jittered to better visualize the number of observations being plot.  Below is an example where the amount of jitter, random variation introduced along the x-axis (named width), is set to a relatively small number to prevent overlapping from the mutually exclusive groups Caniformia and Feliformia.  This plot ignores the non-numerical nature of the x-axis variable in favor of displaying all the data.

The jittered scatterplot highlights a reasonable rule of thumb for visualization: display as much of the original data as possible, without cluttering the plot.

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```R
library(ggplot2)
carnivora <- read.csv("https://raw.githubusercontent.com/roualdes/data/master/carnivora.csv")
```
</div>

</div>

<div markdown="1" class="cell code_cell">
<div class="input_area hidecode" markdown="1">
```R
update_geom_defaults("point", list(colour = "blue"))
update_geom_defaults("density", list(colour = "blue"))
update_geom_defaults("path", list(colour = "blue"))
old <- theme_set(theme_bw() + theme(text = element_text(size=18)))
```
</div>

</div>

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```R
ggplot(data=carnivora, aes(SuperFamily, SW)) + geom_jitter(width=.1)
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

{:.output_png}
![png](../images/normal_models/two_means_3_1.png)

</div>
</div>
</div>

The other plot we'll use when the y-axis variable is numeric and the x-axis variable is categorical is a violin plot.  A violin plot is a density plot turned vertical and one density plot is made for each level of the x-axis categorical variable.  Below is an example.  The violin plot should be used in addition to the jittered scatter plot, or whever the former plot is too cluttered to be meaningful.

Both of these plots help the scientist visualize the location of the mean and variation for the y-axis variable, within each level of the x-axis categorical variable.

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```R
ggplot(data=carnivora, aes(SuperFamily, SW)) + geom_violin()
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

{:.output_png}
![png](../images/normal_models/two_means_5_1.png)

</div>
</div>
</div>

The two means model is the common name for estimating a mean of the y-axis variable, here body weight, for each level of the x-axis variable, here super family.  In reality, it's just estimating means by group when there are exactly two levels within the x-axis grouping variable.

Before we move on, it's informative to see that this model is really doing nothing more than estimating means by group.  The code below, first carefully removes $\texttt{NA}$s, estimates group means using $\texttt{dplyr}$, and then estimates group means using our current model.  The current model produces identical numbers, but only through this intermediate number that doesn't quite make sense yet.

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```R
library(dplyr)
carn <- carnivora %>%
    select(SuperFamily, SW) %>%
    na.omit

carn %>%
    group_by(SuperFamily) %>%
    summarise(mnSB = mean(SW))
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

<div markdown="0" class="output output_html">
<table>
<thead><tr><th scope=col>SuperFamily</th><th scope=col>mnSB</th></tr></thead>
<tbody>
	<tr><td>Caniformia</td><td>23.44421  </td></tr>
	<tr><td>Feliformia</td><td>16.60218  </td></tr>
</tbody>
</table>

</div>

</div>
</div>
</div>

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```R
# HIDDEN
ll <- function(beta, y, mX) {
    sum((y - apply(mX, 1, function(row) {sum(beta * row)}))^2)
}
X <- model.matrix( ~ SuperFamily, data=carn)

(beta <- optim(rexp(2), ll, method="L-BFGS-B", mX=X, y=carn$SW)$par)
sum(beta)
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

<div markdown="0" class="output output_html">
<ol class=list-inline>
	<li>23.4442386143176</li>
	<li>-6.84206338065863</li>
</ol>

</div>

</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

<div markdown="0" class="output output_html">
16.602175233659
</div>

</div>
</div>
</div>

Model notation is based around the idea of an intercept, despite the fact that the word intercept is not well defined here.  What we mean by intercept in this context is the mean value of body weight, the y-axis variable, for the first level of the x-axis variable, here Caniformia.  In $\texttt{R}$, the first level will always be the alphabetically or numerically first level contained in the x-axis categorical variable.

For the body weight data, $\texttt{SW}$, we assume

$$ Y_1, \ldots, Y_N \sim_{iid} \text{Normal}(\mu, \sigma^2) \\
\mu = \beta_0 + \beta_1 * Feliformia.$$

There are three pieces to this model that deserve special attention.  The first thing to notice is that the structure of the model looks identical to simple linear regression.  This similarity will allow us to unify these two models in coming sections of these lecture notes.  The difference between simple linear regression and this model rests on the (statistical) type of the x-axis variable, which brings us to the other pieces that deserve special attention.  

The second point to note is that Feliformia is not a numerical variable, like in simple linear regression.  In the world of statistics, Feliformia in this context is called an indicator variable.  Indicator variables only ever take on two values, $0$ and $1$.  Feliformia will be $1$ when predicting or calculating the mean body weight for an animal from the super family Feliformia, and $0$ otherwise.

The third point to note is that Caniformia does not obviously show up in this model.  It's only when predicting or calculating the mean body weight for an animal from the super family Caniformia that Feliformia is $0$ and thus the term $\beta_0$ represents Caniformia's mean body weight.

The main difference between simple linear regression and this model is the type of the x-axis variable.  In simple linear regression the x-axis variable is numerical.  Here, the x-axis variable is categorical.  This changes our interpretation of the current model.

Now, the "intercept" $\beta_0$ is Caniformia's mean body weight, and the "slope" $\beta_1$ is the offset for Feliformia, relative to Caniformia.  That is, if you take $\hat{\beta}_0$ and add it to $\hat{\beta}_1$, you'll get the estimated mean body weight for Feliformia.

The code to fit this model is very similar to the code for simple linear regression.

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```R
ll <- function(beta, y, mX) {
    sum((y - apply(mX, 1, function(row) {sum(beta * row)}))^2)
}
X <- model.matrix( ~ SuperFamily, data=carn)

(beta <- optim(rexp(2), ll, method="L-BFGS-B", mX=X, y=carn$SW)$par)
sum(beta)
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

<div markdown="0" class="output output_html">
<ol class=list-inline>
	<li>23.4442322987161</li>
	<li>-6.8420557728053</li>
</ol>

</div>

</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

<div markdown="0" class="output output_html">
16.6021765259108
</div>

</div>
</div>
</div>

Notice that $X$ again has two columns.

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```R
head(X)
tail(X)
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

<div markdown="0" class="output output_html">
<table>
<thead><tr><th scope=col>(Intercept)</th><th scope=col>SuperFamilyFeliformia</th></tr></thead>
<tbody>
	<tr><td>1</td><td>0</td></tr>
	<tr><td>1</td><td>0</td></tr>
	<tr><td>1</td><td>0</td></tr>
	<tr><td>1</td><td>0</td></tr>
	<tr><td>1</td><td>0</td></tr>
	<tr><td>1</td><td>0</td></tr>
</tbody>
</table>

</div>

</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

<div markdown="0" class="output output_html">
<table>
<thead><tr><th></th><th scope=col>(Intercept)</th><th scope=col>SuperFamilyFeliformia</th></tr></thead>
<tbody>
	<tr><th scope=row>107</th><td>1</td><td>1</td></tr>
	<tr><th scope=row>108</th><td>1</td><td>1</td></tr>
	<tr><th scope=row>109</th><td>1</td><td>1</td></tr>
	<tr><th scope=row>110</th><td>1</td><td>1</td></tr>
	<tr><th scope=row>111</th><td>1</td><td>1</td></tr>
	<tr><th scope=row>112</th><td>1</td><td>1</td></tr>
</tbody>
</table>

</div>

</div>
</div>
</div>

The first column, as in simple linear regression, is called the intercept and is always $1$.  The second column is $0$ when an observation (row) represents an animal from the super family Caniformia, and is $1$ when an observation represents an animal from the super family Feliformia.  Notice then that the model uses both $\beta_0$ and $\beta_1$ to estimate the mean for members of the super family Feliformia.  This explains why $\beta_1$ is the offset for Feliformia relative to (the ever present) group mean $\beta_0$ for Caniformia.  In the world of data science, they say the variable $\texttt{SuperFamilyFeliformia}$ is one-hot encoded for the observations which are members of the super family Feliformia.  

With this in mind, we can recover the two means of body weight for Caniformia and Feliformia.  Caniformia's estimated mean body weight is $\hat{\beta}_0$ and Feliformia's estimated mean body weight is $\hat{\beta}_0 + \hat{\beta}_1$.

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```R
beta[1]
sum(beta)
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

<div markdown="0" class="output output_html">
23.4442322987161
</div>

</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

<div markdown="0" class="output output_html">
16.6021765259108
</div>

</div>
</div>
</div>

The interpretation of each group's mean is the same as interpretting a single mean.

Quantifying uncertainty in our estimates is carried out with the bootstrap method.

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```R
library(boot)

breg <- function(data, idx) {
    y <- data[idx, 1]
    X <- data[idx, -1]
    optim(rexp(2), ll, method="L-BFGS-B", mX=X, y=y)$par
}

b <- boot(cbind(carn$SW, X), R=999, breg)
bci_beta0 <- boot.ci(b, conf=.9, type="perc", index=1)
bci_beta1 <- boot.ci(b, conf=.9, type="perc", index=2)
```
</div>

</div>

Plotting the bootstrap estimated sampling distributions for Feliformia's offset gives good idea of the similarlity between Caniformia and Feliformia.

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```R
bdf <- as.data.frame(b$t)
names(bdf) <- c('caniformia', 'feliformia_offset')
ggplot(data=bdf, aes(feliformia_offset)) +
    geom_density()
quantile(bdf$feliformia_offset, probs=c(0.1, .5, .9))
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

<div markdown="0" class="output output_html">
<dl class=dl-horizontal>
	<dt>10%</dt>
		<dd>-20.0943690908679</dd>
	<dt>50%</dt>
		<dd>-6.30098640957269</dd>
	<dt>90%</dt>
		<dd>4.89842857233693</dd>
</dl>

</div>

</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

{:.output_png}
![png](../images/normal_models/two_means_18_2.png)

</div>
</div>
</div>

The summary statistics, including the plot, above suggest that there's a reasonable chance that the mean body weight for Feliformia is roughly equal to that of Caniformia.  But be careful with this conclusion, because the violin plot above shows that there's some members of the super family Caniformia that are always heavier than some members of Feliformia.  Do you know which animals these are?
