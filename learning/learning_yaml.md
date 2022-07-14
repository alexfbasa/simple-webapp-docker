# Yaml Object

YAML                     JSON
                         {
key1: 1                     key1: 1
key2: someString            key2: "someString"
                         }


outerKey:                {
  innerKey1: 1              outerKey: {
  innerKey2: 2               innerKey1: 1,
                             innerKey2: 2
                           }
                         }

YAML                    JSON
- 1                   [1,2,3]
- 2
- 3
```yaml YAML
ingredients:
  - Tomato
  - Jalapeno
  - Cilantro
```
```json JSON
{
  ingredients: [
  "Tomato",
  "Jalapeno",
  "Cilantro"
  ]
}
```
```yaml
apiVersion: v1                          TOP-LEVEL
kind: Pod                               TOP-LEVEL
metadata:                               TOP-LEVEL
  name: hello-world-pod                 child object form metadata
  labels:
    app: hello-world-pod
spec:                                   TOP-LEVEL          
  containers:
  - env:
    - name: MESSAGE
      value: Hi! I'm an environment variable
    image: quay.io/practicalopenshift/hello-world
    imagePullPolicy: Always
    name: hello-world-override
    resources: {}
```

```yaml
apiVersion: v1                          TOP-LEVEL
kind: Pod                               TOP-LEVEL
metadata:                               TOP-LEVEL
  name: hello-world-pod                 child object form metadata
  labels:
    app: hello-world-pod
spec:                                   TOP-LEVEL          
  containers:
  - env:
    - name: MESSAGE
      value: Hi! I'm an environment variable
    image: quay.io/practicalopenshift/hello-world
    imagePullPolicy: Always
    name: hello-world-override
    resources: {}
  - env:
      - name: MESSAGE
        value: Hi! I'm an environment variable
    image: quay.io/practicalopenshift/hello-world
    imagePullPolicy: Always
    name: hello-world-override
    resources: {}
```