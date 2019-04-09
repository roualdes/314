---
redirect_from:
  - "/normal-models/k-means"
interact_link: content/normal_models/k_means.ipynb
title: 'k Means'
prev_page:
  url: /normal_models/two_means
  title: 'Two Means'
next_page:
  url: /references
  title: 'References'
comment: "***PROGRAMMATICALLY GENERATED, DO NOT EDIT. SEE ORIGINAL FILES IN /content***"
---

# $k$ Means

This section is the immediate extension from two means to $k$ means. 

The name ANOVA is sometimes used in this setting. ANOVA stands for analysis of analysis of variance, but should be more literally translated to comparing $k$ levels' means.  The reason behind the name ANOVA is that often, but not in this class, the variation amongst the groups compared to variation within the groups gives a reasonable decision rule for determinging when means by level are different.

We continue to work with the dataset $\texttt{carnivora}$.  Now we'll estimate a mean for $k = 4$ of the levels of the categorical variable $\texttt{Family}$: Canidae, Felidae, Mustelidae, and Viverridae. For the body weight data, $\texttt{SW}$, we assume

$$ Y_1, \ldots, Y_N \sim_{iid} \text{Normal}(\mu, \sigma^2) \\
\mu = \beta_0 + \beta_1 * Felidae + \beta_2 * Mustelidae + \beta_3 * Viverridae.$$

Let's plot our data and add the mean as a new layer, now that we're getting good at plotting.  The code below first carefully removes missing data and filters our dataset down to the levels of interest.



{:.input_area}
```R
library(ggplot2)
carnivora <- read.csv("https://raw.githubusercontent.com/roualdes/data/master/carnivora.csv")
```




{:.input_area}
```R
library(dplyr)
carn <- carnivora %>%
    select(Family, SW) %>%
    filter(Family %in% c("Canidae", "Felidae", "Mustelidae", "Viverridae")) %>%
    droplevels

ggplot(carn, aes(Family, SW)) + 
    geom_jitter(width=.1) +
    stat_summary(fun.y="mean", color="orange", geom="point", size=2)


```





{:.output .output_png}
![png](../images/normal_models/k_means_2_1.png)



From the plot above, it seems like Felidae has the greatest mean weight, but it also seems like there is the most variation in Felidae.

Code to fit our model above looks quite similar to our previous efforts in Sections Simple Linear Regression and Two Means.



{:.input_area}
```R
ll <- function(beta, y, mX) {
    sum((y - apply(mX, 1, function(row) {sum(beta * row)}))^2)
}
X <- model.matrix( ~ Family, data=carn)

(beta <- optim(rexp(4), ll, method="L-BFGS-B", mX=X, y=carn$SW)$par)
```



<div markdown="0" class="output output_html">
<ol class=list-inline>
	<li>9.5112452959159</li>
	<li>26.9478270139983</li>
	<li>-4.915414368483</li>
	<li>-6.69996081208209</li>
</ol>

</div>


The same trick is taking place in our model.  The "intercept" is really the first level's mean, Canidae.  Each coefficient after that is a level-specific offset relative to the Canidae's mean.  To find, say, Mustelidae's mean, you have to add $\hat{\beta}_0$ to $\hat{\beta}_2$.



{:.input_area}
```R
beta[1] + beta[3]
```



<div markdown="0" class="output output_html">
4.5958309274329
</div>


These estimates are still no different than group means.  Don't be discouraged, we are building to more complex models than group means.  Nonetheless, here's the empirical evidence.



{:.input_area}
```R
carn %>%
    group_by(Family) %>%
    summarise(mnSW = mean(SW))
```



<div markdown="0" class="output output_html">
<table>
<thead><tr><th scope=col>Family</th><th scope=col>mnSW</th></tr></thead>
<tbody>
	<tr><td>Canidae   </td><td> 9.511111 </td></tr>
	<tr><td>Felidae   </td><td>36.458947 </td></tr>
	<tr><td>Mustelidae</td><td> 4.595667 </td></tr>
	<tr><td>Viverridae</td><td> 2.811250 </td></tr>
</tbody>
</table>

</div>


Quantifying uncertainty in our estimates is carried out with the bootstrap method.



{:.input_area}
```R
library(boot)

breg <- function(data, idx) {
    y <- data[idx, 1]
    X <- data[idx, -1]
    optim(rexp(4), ll, method="L-BFGS-B", mX=X, y=y)$par
}

b <- boot(cbind(carn$SW, X), R=999, breg)
bci_beta0 <- boot.ci(b, conf=.95, type="perc", index=1)
bci_beta1 <- boot.ci(b, conf=.95, type="perc", index=2)
```

