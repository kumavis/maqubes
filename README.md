### maqubes

This is an experiment to bring some QubesOS like experiences to MacOS on Apple Silicon.

### status

experiment. known to be unsafe.

### dependencies

- [`multipass`](https://multipass.run/) by Canonical
- [`X Quartz`](https://www.xquartz.org/)
    - settings: under security, need to "allow connections from network clients"

### usage

```sh
# creates a new vm
./cli.sh create vm1
# runs the "xeyes" application
./cli.sh run vm1 xeyes
```

### comparsion to QubesOS renderer

While QubesOS does use X11, they don't use the same way. They are doing some very custom stuff to achieve performance and security.

See https://www.qubes-os.org/doc/gui/ for more info.