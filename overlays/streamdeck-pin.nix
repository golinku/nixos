final: prev: {
  python3Packages = prev.python3Packages.overrideScope (pyFinal: pyPrev: {
    streamdeck = pyPrev.streamdeck.overridePythonAttrs (old: {
      version = "0.9.6";
      src = prev.fetchPypi {
        pname = "streamdeck";
        version = "0.9.6";
        sha256 = "1vzl7rixf2whq91drmz46wcfqr054k30kpswaq5wc090xf4km4wh";
      };
    });
  });
}
