---
redirect_from:
  - "/normal/single-mean"
interact_link: content/normal/single_mean.ipynb
title: 'Introduction'
prev_page:
  url: /normal/introduction
  title: 'Normal Distribution'
next_page:
  url: 
  title: ''
comment: "***PROGRAMMATICALLY GENERATED, DO NOT EDIT. SEE ORIGINAL FILES IN /content***"
---

# Normal

The first formal model in these notes happened so fast, you might have missed it.  By assuming $X_n \sim_{iid} \text{Bernoulli}(p)$, we created a single model.  This one statistical model assumed the Bernoulli distribution.  Our data consisted of multiple independent observations from the identical distribution (iid), a Bernoulli distribution with unknown population parameter $p$.

In this section, we change the assumed distribution to the Normal distribution.  Because the support for the Normal distribution is all real numbers, this distribution applies to data that could potentially take on any value in the real line.  We complete the section by rehearsing our use of the likelihood function as it applies to Normal data.  When, out in the real world on your own, if don't know what model to apply, assume normality.  

## Single Mean

It's common to assume any single numerical variable data follows a Normal distribution, $ Y_n \sim \text{Normal}(\mu, \sigma)$ for $n = 1, 2, \ldots, N$.  Note that we will call this a formal model although I understand that it is difficult to separate the ideas of distribution and model at this point.
