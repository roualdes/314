---
redirect_from:
  - "/normal-linear-models/introduction"
title: 'Normal Linear Models'
prev_page:
  url: /bootstrap
  title: 'Bootstrap'
next_page:
  url: /normal_linear_models/one_mean
  title: 'One Mean'
comment: "***PROGRAMMATICALLY GENERATED, DO NOT EDIT. SEE ORIGINAL FILES IN /content***"
---
# Normal Linear Models

## Introduction

When specifically only interested in the population mean, the Normal distribution is a common choice.  There's computational, theoretical, and practical arguments for this.  The computational argument acknowledges the simplicity of the log-likelihood of the normal distribution for the mean $\mu$.  The theoretical argument acknowledges the Central Limit Theorem, which tells us that the sampling distribution of the sample mean converges to the normal distribution when the population is well behaved.  The practicality of the Normality assumptions recognizes the implicit identity function that connects the expected value to a linear form.  This practical argument is difficult to recognize until it no longer exists, for instance within logistic regression.  This chapter will focus on normal linear models for computational and practical reasons.