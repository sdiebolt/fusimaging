---
icon: lucide/square-function
---

# Implementation of rs-FC

This post is adapted from [JC Mariani’s
website](https://jcmariani.github.io/processingFC.html) and adapted from his thesis
whose full version can be found [here](https://theses.hal.science/tel-04420129). 

## Introduction

In this section I detail the methodological aspects regarding the analysis of **Functional Connectivity (FC)** patterns. In the last $40$ years, from the first methods developed for **Positon Emission Tomography (PET)** imaging, the field of neuroimaging has strongly standardised its approach. As a result, a set of shared practices has emerged. We present here the theoretical framework behind each of the steps used to compute FC measures. One of the pioneering team in this effort is probably *Karl Friston*’s which proposed the **Statistical Parametric Mapping (SPM)** software, still broadly used in many publications. Most of the step I described below are inspired from this seminal work. These main steps of the analysis, which can be generalised to most analyses of haemodynamics, can be enumerated as follow:

1. **Standardization** is the first step of the analysis which consists in structuring
   the dataset. Do not take this as granted, proper standardization can save you hours
   of work. If you are interested, don’t hesitate to check the [fUSI-BIDS extension
   proposal
   document](https://docs.google.com/document/d/1W3z01mf1E8cfg_OY7ZGqeUeOKv659jCHQBXavtmT-T8/edit?usp=sharing).
2. **Registration** consists in aligning all images in a common coordinate system. To do
   so a common space must be defined, *i.e.* a reference image. Then, a transform
   between the image and the reference must be estimated. Finally, the image is transformed
   to be mapped on this referential. The result of this transform shall ensure equivalence
   between the same voxels of two different images.
3. **Level 1**, is the model at the individual level. It encodes the hypothesis used to
   build an object of interest. This object of interest is an observable, with usually
   reduced degrees of freedom as compared to the initial image. This object represents the
   quantity studied associated to each subject, in our case connectomes.
4. **Level 2**, is the model at the population level. It gathers the objects of interest
   computed at the level  and estimates the significance of their difference after
   gathering them in groups of interest. In other terms it is the measure of the effect
   based on the hypothesis.

We will focus in this document on the last two steps in the case of FC. We remind here
that FC results are observables of dynamical properties of the brain function. Based on
a generative model of brain dynamics, from neuronal activity to neurovascular coupling,
we expect covariance structures to emerge between individual timeseries of our image
voxels. In easier terms some voxels tend to co-vary, we assume these voxels to be
connected, FC is the metrics of these covariance structures. Under a stationarity
hypothesis we can measure this covariance (over typically 10-minute windows) with
Pearson's correlation coefficient (most classically). Based on the model of FC we can
interpret this observable (correlation between voxels or parcels) as connectivity
between regions of the brain. As such, it is critical to remember that FC can be
influenced by any stage of the model. Therefore, interpretation of FC changes must be
always carried with caution as a drop of connectivity could mean loss of information
transfer between two regions but also reduction of neurovascular coupling or network
influence on regional dynamics. The interpretation of these FC variations is an open
field of research as conventional (static) FC distill many aspects of the dynamics in a
powerful but simplified metrics.

## FC Model

The model of FC is detailed in [another page of this
website](http://jcmariani.github.io/principleFC.html). I summarize here the different
steps of the reasoning behind the metric.

1. The brain is a complex network of neurons which acts as integrator of information that propagates along axons and dendrite
    - This network possess scaling properties which allow identifying more or less
      homogeneous regions.
    - These regions can be approximated as a local interaction between two populations
      of excitatory and inhibitory neurons. This results in a local dynamic of the network
      that can be modeled as a dynamical system driven by differential equations (like an
      oscillator)[^deco_2011].
    - There exist long range connections between these regions which introduces a
      coupling between the different regions.
2. The vascular system densely perfuses the brain tissue, and blood flow is locally
   enslaved by neuronal activity as a low pass transfer function with a characteristic
   time of a few seconds:
    - In a feedforward model local activity of neurons results in an increase of blood
      perfusion to maintain homeostasis through the neurovascular
      coupling[^iadecola_2017][^schaeffer_2021].
    - Alternatively other models of neurovascular coupling propose that oscillations of
      local neuronal population (gamma oscillations) induces vasomotion
      fluctuations[^mateo_2017].
    - Overall we make the approximation (independently of the direct mechanism) that if
      we observe covariance in the haemodynamic signal, due to the neuronal drive over
      blood flow, this feature translates neuronal coupling. This point is critical and
      requires that no other source of covariance exists in our signal, hence the decades
      of research in the best way to denoise time series.

Using this framework, if two regions possess a strong “connectivity”, as formulated by the Hebbian principle, it is assumed that they would share some synchronous neuronal activity. Finally, if two regions haemodynamic signals are synchronous, as these signals are driven by neuronal activity they must be connected.

![](https://jcmariani.github.io/assets/img/post-02_introduction_FC_principle.png)

///caption
**Fig1.** Illustration of the FC model. Local population of excitatory and inhibitory neurons drive local blood flow. Long range connectivity drive synchronicity of between brain regions inducing correlation in haemodynamic signal. Middle, example of CBV bilateral correlation between two two regions of the rat cortex. Top at the baseline, bottom after injection of cannabinoids which perturb the synchronicity.
///

## First Level Analysis

As a consequence of the first section we can conclude that a good metric for in-between regions connectivity is the measure of correlation of blood dynamics in a slow regime due to latency of the vascular system. More formally speaking FC can be defined as the measure of second order statistics of the haemodynamic signal. We can use the **Cerebral Blood Volume (CBV)** filtered in the infra-slow regime ($<0.1Hz$), as any higher frequency could not come from slow neurovascular coupling and can not be explained by neuronal source. In addition, we must eliminate alternative sources of slow covariance that are independent of neuronal activity. Otherwise, the FC could be artificially inflated, as demonstrated by studies showing the influence of motion or cardiac and respiratory rhythms [^power_2017]. In the end, the first part of the model we make at the first level is that the signal of interest can be decomposed as:

$$
y=y_{FC}+y_{confounds}+\epsilon
$$

Where $y$ is the signal, $y_{FC}$ the neuronally driven FC oscillation in the infra-slow band, $y_{confounds}$ a linear combination of coherent artefactual sources and $\epsilon$ some white noise. In other terms, we hypothesise that it is possible to extract a good estimate of neuronally driven vascular fluctuations by removing confounding nuisances and filtering in the infra-slow band. It is why developing optimal methods for nuisance removal has become a main subfield of neuroimaging. This question, ad most notably the motion artefact, are further discussed below. In the meantime it is worth mentioning that the main nuisance removal strategies are: detrend for removing slow drifts expected to come from hardware sources [^liu_2017], cardiac and breathing regression [^bhattacharyya_2004][^shmueli_2007][^liu_2016], motion regression [^friston_1995], the global signal regression [^power_2017], principal component based regression [^behzadi_2007], censoring of artefactual frames or scrubbing [^power_2012].

Finally, given $yFC$ we hypothesise that the measure of covariance in two signals is proportional to, or at least monotonous in, the underlying functional connectivity of the regions it was extracted from. For this purpose the most metric is probably the *Pearson*’s correlation coefficient (if you are curious Liu 2024[^liu_2024] lists 238 alternative pairwise interaction statistics):

$$
c(i,j)=\frac{<yi,yj>}{\sqrt{<yi,yi><yj,yj>}}
$$

Where $y_i$ and $y_j$ are two signals respectively extracted from region $i$ and region $j$ if $y_i$ and $y_j$ are centred (null mean).

Under validity of the model, by combining these two steps we can infer the connectivity between two regions. In practice two canonical objects are used to gather these properties of the brain. With correlation matrices **Region of Interest (ROI)** are defined, either based on the brain anatomy or functional criterion (identification of regional clusters or **Independent Component Analysis (ICA)** based). The signals are extracted from these ROIs and the connectome encoded in a **Correlation Matrix (CM)** which represents pair wise correlations. Alternatively we can define one signal of reference, called the seed, and measure the connectivity of any other voxel with this seed. The seed signal is usually also extracted from a ROI in which case we refer the voxel wise correlation distribution as a **Seed Based Map (SBM)**. Alternatively the seed can be artificial in which case the object is usually referred to as an activation or correlation map.

## Second Level

The further down we go in the analysis, the more options are available. Consequently,
there is no way to even get close to an exhaustive list of potential second levels. As a
result, here, we only remind the fundamental concept, which is also shared with most
other scientific areas, we also give below suggestion to implement your own statistical
pipeline.

From the first level we obtain a descriptor of each individual in the shape of a CM or a
SBM. The question we ask at the group level is whether two such collections are
different within a population, and if it is the case, what are these differences. The
classical methods for CM and SBM rely on mass univariate approaches. All voxels are
independently compared between the two groups. This method has pitfalls which are more
detailed below. Alternatively, multivariate analysis could be used like **Principal
Component Analysis (PCA)** for example.

In the end, the method to use depends on the question you ask. It is the real
translation of the working hypothesis in terms of statistics. If the effect is expected
to have multilinear basis, an other GLM could be used. With the advances in machine
learning and related tools, it becomes more common to use predictors and classifiers to
perform such second level statistics.

## **Mass Univariate T-test**

The underlying idea behind this method is to consider the different components of the
object of interest, whether its is a CM pixel or a SBM voxel, as independent. In this
case, the null hypothesis can be spread across them all. A null hypothesis is tested
element wise. The most common practice is to compute the difference between two
distributions of correlation coefficient (a control group and experimental one or a
baselive VS an active phase). From this test a $t−value$ is computed. This $t−value$ can
be translated into a $p−value$ whose threshold, in absence of *prior* knowledge on the
system can be arbitrarily defined at $5\%.$ Interpreting this parallel testing requires
corrections for multiple comparisons (see below). The *Benjamini Hochberg* procedure
permits to control the false discovery rate [^benjamini_1995]. After this step,
significance is given element wise. For example CM significant changes between two
conditions is given in the form of a matrix whose pixels are binary value. The value of
an elemnt informs if the CM pixel has changed significantly in respect to the overall
distribution of the changes.

As an example [^mariani_2024], most classically, the connectome of a group of $9$ mice
after drug injection is compared to the connectomes of a group of $11$ mice after saline
injection. If the connectome is defined as a correlation matrix between $10$ ROIs, a
test is performed for each edge of the network or pixel of the lower triangle of the
matrix ($n_{test}=n_{vox}(n_{vox}−1)/2= 45$ tests). Each test compares the coefficients
at the same position in the matrix for all $9$ mice for the first distribution,
and $11$ mice for the second distribution. A $t−value$ is computed to quantify the
distance between both distributions. Each $t−value$ can be translated into
a $p−value$ to infer the chance that both distributions are coming from the same sample
given the number of individuals in each group and the values of their coefficients.
Because under the null hypothesis, the chance to reject it is proportional to the number
of repeated tests, $p−values$ tend to overestimate the number of discoveries. The
$p-value$ must be corrected to control this risk of false discovery. We use *Benjamini
Hochberg* procedure to do so. All significant changes correspond to $q−values <0.05$.

## **Fisher transform**

In the case of the *Pearson’s correlation coefficient, all the aforementioned procedures must follow a *Fisher* transform of the coefficient. Indeed, because the correlation coefficient is included in $[−1,1]$ its variance is reduced for extreme values. The fisher transform $r\mapsto arctanh(r)$ spreads correlation coefficients on the whole $R$. It does so by giving a distribution almost normal whose variance is independent of $r$. By using the $Fisher$ transform, the correlation coefficient can be handled as a $z−vlalue$. Nevertheless, one must keep in mind that a *Fisher* transformed coefficient is not a $z−value$ *per se*. The space where correlation coefficient are transformed is called the *Fisher*’s space. For visualisation purposes it is more natural to observe the correlation coefficient in the correlation space ($r∈[−1,1]$). Therefore, usually, coefficients are first sent in the *Fisher* space where then can be handled as $z−score$ to be compared or to compute an average, before being transformed back on the correlation space for visualisation.

## **Statistical Decision Tree**

Based on Rahal *et al.*, 2020 [^rahal_2020], you can define your "t−test" strategy
based on a decision tree:

- A  $ShapiroWilk$ test is performed with test for $α=0.1$
    - If the null hypothesis is rejected *i.e.* distribution is not Gaussian a non parametric *Wilcoxon-Mann-Whitney* test is performed.
    - If the null hypothesis is not rejected, variance equality is tested with a $F-test$, two-tailed $\alpha = 0.05$.
        - If the variances are equal, an equal variance $t-test$ is performed, two-tailed $\alpha = 0.05$
        - If the variances are not equal, an unequal variance $t-test$ is performed, two-tailed $\alpha = 0.05$

Whatever the object of interest, all its degrees of freedom (individual voxels of the
seed-based map or cells connectivity matrix) are tested independently following this
procedure. After this step, the collection of $p−values$ are corrected
to $q−values$ for multiple comparisons induced false positive rate control (see
below). Then, the null hypothesis is rejected with $\alpha = 0.05$.

## **Multiple comparison**

The problem of multiple comparison is perfectly illustrated in [^bennett_2009] who
identified significant clusters of voxels responding to a visual task in the brain of a
dead salmon. The underlying principle rests in the fact that the number of false
positives is linearly linked to the number of independent tests performed. For classical
neuroimaging studies the number of tests is equal to the number of voxels, in the order
of magnitude of $\simeq10^6$ ($10^4$ for 2D fUSI).

The most common approach to correct statistical results obtained for parallel testing
is *Bonferroni*'s correction method. In this case, the linear increase in false
positives is countered by inversely reducing the threshold
for $TypeI$ errors $\alpha=\alpha_0/n$ where $\alpha_0$ is the single test threshold
(usually $0.05$) and $n$ the number of tests. **Bonferroni**’s correction is known to be
a peculiarly stringent correction as it considers all tests independent, which is not
necessarily the case and peculiarly for neuroimaging where correlation structures exist
between neighbouring voxels [^lindquist_2015].

Alternatively, applying the **Random Field Theory** *Euler*’s characteristic was found a
good quantifier to control the **Family Wise Error Rate (FWER)** which is
the αα equivalent when multiple tests are performed. Without entering in the details of
this procedure the *Euler*’s characteristic estimates the number of connected clusters
above a certain threshold inside an image of a certain smoothness. As a result, using
this strategy controls for correlation structure, dealing with clusters instead of
independent tests. The RFT assumes that images are discrete sampling of continuous
smooth random fields. This assumption is quite strong, to ensure this characteristic,
smoothing kernels are usually applied to the images as a required step of preprocessing.
Finally, *Euler*’s characteristic is function of this estimated smoothness of the random
field. It was shown for low smoothness, that RFT based FWER is more stringent
than *Bonferroni*’s correction[^nichols_2003].

Finally, two methods have bee proposed to increase power of *Bonferroni*'s correction.
*Holm*'s step-down method and *Benjamini*'s step up method or *Benjamini-Hochberg*
procedure[^benjamini_1995] use an iterative process over sorted *p*−values to refine
research for maxima, well suited in the case of correlated tests[^nichols_2003]. The
idea here is not to control the FWER (that is, overall number of false positive), but
the **False Discovery Rate** (that is, the number of false discovery in the population
of tests who rejected the null hypothesis, the ones for which the test is considered
significant). For example, with *Benjamini*’s method if we call $p_0 < p_1 < ... < p_i <
...< p_n$ the set of our $n$ *p*−values sorted in increasing values. To correct for
an FDR of $q = 0.05$ (that is, we want to control that the number of
false positive within rejected tests is below $5\%$), if $r$ is the maximal
value so that $p_r \leq \frac{i}{n}q$, then all tests for which $p_i \leq
p_r$ reject the null hypothesis. As explained in[^lindquist_2015], any procedure
controlling FWER controls the FDR yielding to increased power of FDR, moreover it
doesn't assume any *a priori* information on the distributions tested as opposed to RFT
based control. In the end, for all these reasons, FDR correction is among the most
popular method to solve the multiple comparison problem[^nichols_2003].

## Summary

We showed here how the concepts introduced in [the FC principle
post](functional-connectivity.md) could be translated into mathematical formulations.
Neuroimaging methods allow the measure of blood flow properties which ultimately is
digitalised. From these images a succession of programs and algorithms permit to apply
the fundamental principles of functional connectivity. By this succession of transforms,
the image is ouput as simple objects that can be studied in the frameworks of classical
statistics. We finally introduced the main statistical caveat associated with
neuroimaging analyses.

[^deco_2011]: Deco, G., Jirsa, V. K., and McIntosh, A. R. (2011). Emerging concepts for the dynamical organization of resting-state activity in the brain. *Nat. Rev. Neurosci.*, 12(1):43–56.
[^iadecola_2017]: Iadecola, C. (2017). The neurovascular unit coming of age: a journey through neurovascular coupling in health and disease. *Neuron*, 96(1):17–42.
[^schaeffer_2021]: Schaeffer, S. and Bhatt, D. (2021). Cerebrovascular disease and vascular cognitive impairment: the brain-heart nexus. In Iadecola, C., editor, *Neurovascular Coupling*. Academic Press.
[^mateo_2017]: Mateo, C., Knutsen, P. M., Tsai, P. S., Shih, A. Y., and Kleinfeld, D. (2017). Entrainment of arteriole vasomotor fluctuations by neural activity is a basis of blood-oxygenation-level-dependent "resting-state" connectivity. *Neuron*, 96(4):936–948.e3.
[^power_2017]: Power, J. D., Plitt, M., Laumann, T. O., and Martin, A. (2017). Sources and implications of whole-brain fMRI signals in humans. *NeuroImage*, 146:609–625.
[^liu_2017]: Liu, T. T. (2016). Noise contributions to the fMRI signal: an overview. *NeuroImage*, 143:141–151.
[^bhattacharyya_2004]: Bhattacharyya, P. K. and Lowe, M. J. (2004). Cardiac-induced physiologic noise in tissue is a direct observation of cardiac-induced fluctuations. *Magnetic Resonance Imaging*, 22(1):9–13.
[^shmueli_2007]: Shmueli, K., van Gelderen, P., de Zwart, J. A., Horovitz, S. G., Fukunaga, M., Jansma, J. M., and Duyn, J. H. (2007). Low-frequency fluctuations in the cardiac rate as a source of variance in the resting-state fMRI BOLD signal. *NeuroImage*, 38(2):306–320.
[^liu_2016]: Liu, T. T. (2016). Noise contributions to the fMRI signal: an overview. *NeuroImage*, 143:141–151.
[^friston_1995]: Friston, K. J., Ashburner, J., Frith, C. D., Poline, J. B., Heather, J. D., and Frackowiak, R. S. J. (1995). Spatial registration and normalization of images. *Human Brain Mapping*, 3(3):165–189.
[^behzadi_2007]: Behzadi, Y., Restom, K., Liau, J., and Liu, T. T. (2007). A component based noise correction method (CompCor) for BOLD and perfusion based fMRI. *NeuroImage*, 37(1):90–101.
[^power_2012]: Power, J. D., Barnes, K. A., Snyder, A. Z., Schlaggar, B. L., and Petersen, S. E. (2012). Spurious but systematic correlations in functional connectivity MRI networks arise from subject motion. *NeuroImage*, 59(3):2142–2154.
[^liu_2024]: Liu, T. T., Falahpour, M., and Bhogawar, N. K. (2024). Comparison of 238 pairwise interaction statistics for resting-state fMRI functional connectivity. *bioRxiv*. [Link](https://www.biorxiv.org/content/10.1101/2024.05.07.593018v1).
[^benjamini_1995]: Benjamini, Y. and Hochberg, Y. (1995). Controlling the false discovery rate: a practical and powerful approach to multiple testing. *J. R. Stat. Soc. Ser. B*, 57(1):289–300.
[^mariani_2024]: Mariani, J. C., Diebolt, S., et al. (2024). Pharmaco-functional ultrasound imaging in awake head-fixed mice. *In preparation*.
[^rahal_2020]: Rahal, R. M. and Bhatt, M. A. (2020). A decision tree for statistical tests. *Nat. Methods*, 17:223.
[^bennett_2009]: Bennett, C. M., Baird, A. A., Miller, M. B., and Wolford, G. L. (2009). Neural correlates of interspecies perspective taking in the post-mortem Atlantic salmon. *NeuroImage*, 47(Suppl 1):S125.
[^lindquist_2015]: Lindquist, M. A. (2015). The statistical analysis of fMRI data. *Stat. Sci.*, 23(4):439–464.
[^nichols_2003]: Nichols, T. and Hayasaka, S. (2003). Controlling the familywise error rate in functional neuroimaging: a comparative review. *Stat. Methods Med. Res.*, 12(5):419–446.
