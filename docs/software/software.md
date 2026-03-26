---
icon: lucide/computer
---

# Software

## fUSI-Specific Software

Software specific to fUSI is still scarce, but there are some resources that can be
useful for the analysis of fUSI data. Here we list some of them, but this is a
non-exhaustive list. If you know of other resources that you think should be added here,
please reach out on our [community
server](https://discord.com/channels/1309093618325131274) to let us know!

### ConfUSIus

[ConfUSIus](https://confusius.tools) is a Python package and napari plugin for handling,
visualization, preprocessing, and statistical analysis of fUSI data. ConfUSIus offers
the following features:

- **I/O Operations**: Load and save fUSI data in various formats (AUTC, EchoFrame,
  Iconeus, NIfTI, Zarr), with automatic fUSI-BIDS sidecars for NIfTI.
- **Beamformed IQ Processing**: Process raw beamformed IQ signals into power Doppler,
  velocity, and other derived metrics.
- **Quality Control**: Compute quality metrics (DVARS, tSNR, CV) to assess data quality
- **Registration**: Motion correction and spatial alignment tools.
- **Brain Atlas Integration**: Map fUSI data to standard brain atlases for region-based
  analysis.
- **Signal Extraction**: Extract signals from regions of interest using spatial masks.
- **Signal Processing**: Denoising, filtering, detrending, and confound regression.
- **Visualization**: Rich plotting utilities for fUSI data exploration.
- **Napari Plugin**: Interactive data loading, live signals inspection, and quality
  control directly in the napari viewer—no scripting required.
- **Xarray Integration**: Seamless integration with Xarray for labeled multi-dimensional
  arrays.

### PyfUS


[PyfUS](https://pyfus.readthedocs.io/en/latest) is a collection of tools dedicated to
the analysis of fUSI. These modules can be used for: registration preprocessing,
timeseries analysis, clustering, feature extraction, correlation analysis, etc.

## General Neuroimaging Tools

fUSI data can be stored in the NIfTI format, an open file format commonly used to store
brain imaging data and widely used in fMRI. This means that many tools developed for
fMRI can be used for fUSI data as well. In Python, we recommend looking into the
following libraries:

- [nibabel](https://nipy.org/nibabel/gettingstarted.html) for loading and saving NIfTI
  neuroimaging data,
- [nilearn](https://nilearn.github.io/stable/index.html) for tools to analyze NIfTI
  neuroimaging data, including great processing for functional connectivity in [this
  part](https://nilearn.github.io/stable/connectivity/index.html).
