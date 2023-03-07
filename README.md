# autoincrement-version
Action to auto increment version code & name defined in files

### To use in your workflow:
```
- name: Auto Increment Version
  id: autoincrement-version
  uses: jonnahrinos/autoincrement-version@v1
  with:
    filepath: {The path to properties file used in gradle to get the version code and name}
    major: true/false
    minor: true/false
    patch: true/false
    versioncode: ${{ github.run_number }}

```

### Expected format for properties file
```
MINOR=0
MAJOR=1
PATCH=0
VERSION_CODE=1
VERSION_NAME=1.0.0
```

### Sample snippet in build.gradle file to set version code and name
```
    def versionPropsFile = file('version.properties')
    Properties versionProps = new Properties()
    if (versionPropsFile.canRead()) {
        versionProps.load(new FileInputStream(versionPropsFile))
    }
    
    versionCode versionProps['VERSION_CODE'].toInteger()
    versionName versionProps['VERSION_NAME']
```