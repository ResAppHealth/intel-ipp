{ stdenvNoCC, writeText, fetchurl, rpmextract, undmg }:

stdenvNoCC.mkDerivation rec {
  name = "ipp-${version}";
  version = "${date}.${rel}";
  date = "2019.3";
  rel = "199";

  src = if stdenvNoCC.isDarwin
    then
      (fetchurl {
        url = "http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/15234/m_ipp_${version}.dmg";
        sha256 = "0n9n2shvzf4blldcws1fx1dp8av122mx8lmsrjbsgzy9bfyalhxk";
      })
    else
      (fetchurl {
        url = "http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/15276/l_ipp_${version}.tgz";
        sha256 = "13rb2v2872jmvzcqm4fqsvhry0j2r5cn4lqql4wpqbl1yi000000";
      });

  buildInputs = if stdenvNoCC.isDarwin then [ undmg ] else [ rpmextract ];

  buildPhase = if stdenvNoCC.isDarwin then ''
      for f in Contents/Resources/pkg/*.tgz; do
          tar xzvf $f
      done
  '' else ''
    # TODO update this to the real RPMs
    rpmextract rpm/intel-mkl-common-c-${date}-${rel}-${date}-${rel}.noarch.rpm
    rpmextract rpm/intel-mkl-core-rt-${date}-${rel}-${date}-${rel}.x86_64.rpm
    rpmextract rpm/intel-openmp-19.0.3-${rel}-19.0.3-${rel}.x86_64.rpm
  '';

  installPhase = if stdenvNoCC.isDarwin then ''
      mkdir -p $out/lib

      cp -r compilers_and_libraries_${version}/mac/ipp/include $out/

      cp -r compilers_and_libraries_${version}/licensing/ipp/en/license.txt $out/lib/
      cp -r compilers_and_libraries_${version}/mac/compiler/lib/* $out/lib/
      cp -r compilers_and_libraries_${version}/mac/ipp/lib/* $out/lib/
  '' else ''
      mkdir -p $out/lib

      cp -r opt/intel/compilers_and_libraries_${version}/linux/ipp/include $out/

      cp -r opt/intel/compilers_and_libraries_${version}/linux/compiler/lib/intel64_lin/* $out/lib/
      cp -r opt/intel/compilers_and_libraries_${version}/linux/ipp/lib/intel64_lin/* $out/lib/
      cp license.txt $out/lib/
  '';

  # Per license agreement, do not modify the binary
  dontStrip = true;
  dontPatchELF = true;

  # Since these are unmodified binaries from Intel, they do not depend on stdenv
  # and we can make them fixed-output derivations for cache efficiency.
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = if stdenvNoCC.isDarwin
    then "00xhamm6jjbjqq1yd09lc58mxdhggbh6dqlrn7yxa1c7pw8ycw0i"
    # TODO update this HASH
    else "101krzh2mjbfx8kvxim2zphdvgg7iijhbf9xdz3ad3ncgybxbdvw";

  meta = with stdenvNoCC.lib; {
    description = "Intel® Integrated Performance Primitives";
    longDescription = ''
    Intel® Integrated Performance Primitives (Intel® IPP) provides developers with high-quality, production-ready, low-level building blocks for image processing, signal processing, and data processing (data compression and decompression, and cryptography) applications.
    '';
    homepage = https://software.intel.com/en-us/intel-ipp;
    license = licenses.issl;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    # maintainers = [ maintainers.bhipple ];
  };
}
