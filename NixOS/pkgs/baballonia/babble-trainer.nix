{
  config,
  pkgs,
  lib,
  cudaSupport ? config.cudaSupport,
  rocmSupport ? config.rocmSupport,
  ...
}:
let
  py3Pkgs = pkgs.python314Packages;

  babble-trainer-src = pkgs.fetchFromGitHub {
    owner = "Project-Babble";
    repo = "BabbleTrainer";
    rev = "1.3.8-linux-paths";
    hash = "sha256-ECK4ApmPl2X41w8yshjUTdZleR4X3Tmh47r0CO28f0Y=";
  };

  opencv2 = pkgs.opencv.override (old: {
    enableGtk2 = true;
  });

  babble-data = py3Pkgs.buildPythonPackage {
    pname = "babble_data";
    version = "1.3.8-linux-paths";
    src = "${babble-trainer-src}/babble_data";
    pyproject = true;
    build-system = [ py3Pkgs.setuptools ];
    buildInputs = [
      py3Pkgs.numpy
      opencv2
    ] ++ lib.optionals cudaSupport [ pkgs.cudaPackages.cudatoolkit ];
    nativeBuildInputs = [ pkgs.pkg-config ];
  };

  # Python depedencies we should have. For some reason,
  # nixpkgs do not include all ONNX support packages so
  # we have to fetch them ourselves.
  pythonEnv = pkgs.python314.withPackages (ps: [
    py3Pkgs.torch
    # Direct depedencies:
    py3Pkgs.numpy
    py3Pkgs.onnx
    py3Pkgs.opencv-python
    py3Pkgs.pillow
    py3Pkgs.tqdm
    # Indrect depedency for ONNX exporting:
    py3Pkgs.torchvision
    py3Pkgs.onnx-ir
    (py3Pkgs.onnxscript.overridePythonAttrs (old: {
      doCheck = false;
      patches = (old.patches or []) ++ [
        ./onnxscript_debug.patch
      ];
    }))
    babble-data
  ]);
in
py3Pkgs.buildPythonPackage {
  pname = "babble-trainer";
  version = "1.3.8";
  pyproject = false;
  doCheck = false;

  src = babble-trainer-src;

  # The original project uses pyinstaller with a .spec-file.
  # We don't really need that because we can ensure that the
  # right depedencies are installed ourselves. We instead add
  # a shebang pointing to our own python environment!
  #
  # TODO If BabbleTrainer every becomes more complex, we may need to
  # to redirect from /bin to /lib to not pollute /bin!
  buildPhase = ''
    mkdir -p $out/bin
    echo "#!${pythonEnv}/bin/python3" > $out/bin/babble-trainer
    cat main.py >> $out/bin/babble-trainer
    chmod +x $out/bin/babble-trainer

    cp trainer_distsampler.py $out/bin/
    cp models.py $out/bin/
    cp data.py $out/bin/
  '';

  installPhase = ''
    # Skipped!
  '';

  patches = [
    ./filepath_fixes.patch
  ];

  meta = {
    description = "BabbleTrainer";
    platforms = pkgs.lib.platforms.linux;
    maintainers = with lib.maintainers; [ toasteruwu ];
  };
}
