## chi2residuals R-package


### package installation
```r
library(devtools)
install_github("cdesterke/chi2residuals")
```

### load library and perform preprocess with variable selection
```r
library(chi2residuals)
data(patients)
str(patients)
head(patients,n=10)
sub <- preProcess(patients, v1 = "AgeGroup", v2 = "PrimarySymptom")
head(sub,n=10)
```

![res](https://github.com/cdesterke/chi2residuals/blob/main/screen.png)

### compute chi2 residuals for the 2 selected qualitative variables

```r
residuals <- computeResiduals(sub, col1 = "AgeGroup", col2 = "PrimarySymptom")
```
![res](https://github.com/cdesterke/chi2residuals/blob/main/residuals.png)

### draw heatmap of the results with significant residuals
```r
plotResiduals(residuals,
              col1 = "AgeGroup",
              col2 = "PrimarySymptom",
              themeSize = 20,
              labelSize = 5,
              colorLow = "turquoise",
              colorHigh = "purple",
              colorLabels = "white",
              title = "Significant residuals p<0.05")
```
![res](https://github.com/cdesterke/chi2residuals/blob/main/heatmap.png)
