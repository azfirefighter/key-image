{ pkgs, ... }: {
  environment.interactiveShellInit = ''
    export GNUPGHOME=/run/user/$(id -u)/gnupghome
    if [ ! -d $GNUPGHOME ]; then
      mkdir $GNUPGHOME
    fi
    cp ${pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/drduh/config/662c16404eef04f506a6a208f1253fee2f4895d9/gpg.conf";
      sha256 = "118fmrsn28fz629y7wwwcx7r1wfn59h3mqz1snyhf8b5yh0sb8la";
    }} "$GNUPGHOME/gpg.conf"
    echo "\$GNUPGHOME has been set up for you. Generated keys will be in $GNUPGHOME."
  '';

  environment.systemPackages = with pkgs; [
    yubikey-personalization
    cryptsetup
    pwgen
  ];

  services = {
    udev.packages = with pkgs; [ yubikey-personalization ];
    pcscd.enable = true;
  };
  users.extraUsers.root.initialHashedPassword = "";

  networking.wireless.enable = false;
  networking.dhcpcd.enable = false;
}
