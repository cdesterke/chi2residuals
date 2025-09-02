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

### test

