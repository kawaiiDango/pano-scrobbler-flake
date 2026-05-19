{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  tag,
  version,
  arch,
  hash,

  webkitgtk_6_0,
  libxtst,
  glib-networking,
  ...
}:

stdenv.mkDerivation {
  pname = "pano-scrobbler-bin";
  inherit version;

  src = fetchurl {
    url = "https://github.com/kawaiiDango/pano-scrobbler/releases/download/${tag}/pano-scrobbler-linux-${arch}.tar.gz";
    inherit hash;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  # Runtime dependencies
  buildInputs = [
    webkitgtk_6_0
    libxtst
  ];

  dontBuild = true;
  dontConfigure = true;
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,opt/pano-scrobbler/lib,share/{applications,icons/hicolor/scalable/apps}}

    cp *.so pano-scrobbler LICENSE $out/opt/pano-scrobbler
    cp lib/*.so $out/opt/pano-scrobbler/lib
    chmod +x $out/opt/pano-scrobbler/pano-scrobbler
    makeWrapper $out/opt/pano-scrobbler/pano-scrobbler $out/bin/pano-scrobbler \
      --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules"

    substituteInPlace pano-scrobbler.desktop \
      --replace-fail "Exec=" "Exec=pano-scrobbler %U" \
      --replace-fail "Icon=" "Icon=pano-scrobbler"
    cp pano-scrobbler.desktop $out/share/applications
    cp pano-scrobbler.svg $out/share/icons/hicolor/scalable/apps/pano-scrobbler.svg

    runHook postInstall
  '';

  meta = with lib; {
    description = "Feature packed cross-platform music tracker";
    homepage = "https://github.com/kawaiiDango/pano-scrobbler";
    license = licenses.gpl3Plus;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "pano-scrobbler";

  };
}
