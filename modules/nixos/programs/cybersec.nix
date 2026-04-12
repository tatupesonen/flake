_: {
  den.aspects.cybersec.nixos = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      # Recon & enumeration
      nmap
      rustscan
      gobuster
      ffuf
      nikto
      enum4linux

      # Exploitation
      metasploit
      sqlmap
      hydra

      # Networking
      wireshark
      tcpdump
      netcat-gnu
      proxychains-ng
      socat
      mitmproxy

      # Password cracking
      john
      hashcat

      # Binary analysis & RE
      ghidra
      radare2
      binwalk
      gdb

      # Web
      burpsuite
      curl
      wget

      # Forensics & crypto
      exiftool
      cyberchef
      steghide

      # AD / Windows
      evil-winrm
      samba

      # Scripting
      python3
      python3Packages.pwntools
      python3Packages.impacket
      python3Packages.requests
    ];
  };
}
