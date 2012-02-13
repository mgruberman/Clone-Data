#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

static SV * clone_sv(SV* sv);

static SV *
clone_av(SV *old) {
  AV *new;
  SV **svp;
  I32 i;
  I32 len = av_len((AV*) old);
  
  new = newAV();
  av_extend(new, len);
  for (i = 0; i <= len; ++i) {
    svp = av_fetch((AV*) old, i, 0);
    av_store(new, i,
        svp ? clone_sv(*svp) : &PL_sv_undef);
  }
  return newRV_noinc((SV*) new);
}

static SV *
clone_hv(SV *old) {
  SV *val, *key;
  HV *new;
  HE *he;

  new = newHV();
  hv_iterinit((HV*) old);
  while (he = hv_iternext((HV*) old)) {
    key = hv_iterkeysv(he);
    val = hv_iterval((HV*) old, he);
    hv_store_ent(new, key,
        val ? clone_sv(val) : &PL_sv_undef,
        0);
  }
  return newRV_noinc((SV*) new);
}

static SV *
clone_rv(SV *sv)
{
  SV *new;
  SvGETMAGIC(sv);
  switch (SvTYPE(sv)) {
    case SVt_PVHV:
      new = clone_hv(sv);
      break;
    case SVt_PVAV:
      new = clone_av(sv);
      break;
    default:
      new = newRV_noinc(clone_sv(sv));
      break;
  }

  if (SvOBJECT(sv)) {
    sv_bless(new, SvSTASH(sv));
  }

  return new;
}

static SV *
clone_sv(SV *sv)
{
  SvGETMAGIC(sv);
  if (SvPOKp(sv)) {
    STRLEN len;
    char *str = SvPV(sv, len);
    return newSVpvn_utf8(str, len, SvUTF8(sv));
  } else if (SvNOK(sv)) {
    return newSVnv(SvNV(sv));
  } else if (SvUOK(sv)) {
    return newSVuv(SvUV(sv));
  } else if (SvIOK(sv)) {
    return newSViv(SvIV(sv));
  } else if (SvROK(sv)) {
    return clone_rv(SvRV(sv));
  } else {
    return &PL_sv_undef;
  }
}

MODULE = Clone::Data		PACKAGE = Clone::Data

PROTOTYPES: DISABLE

void clone(...)
  PPCODE:
    int i;
    for (i = 0; i < items; ++i) {
      XPUSHs(clone_sv(ST(i)));
    }
