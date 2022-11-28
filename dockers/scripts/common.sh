shopt -s expand_aliases
inst_deb_or_dnf()
{
  if command -v apt &> /dev/null
  then
    alias inst='apt'
  else
    alias inst='dnf'
  fi
}

inst_deb_or_dnf