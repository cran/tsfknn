// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

#ifdef RCPP_USE_GLOBAL_ROSTREAM
Rcpp::Rostream<true>&  Rcpp::Rcout = Rcpp::Rcpp_cout_get();
Rcpp::Rostream<false>& Rcpp::Rcerr = Rcpp::Rcpp_cerr_get();
#endif

// first_n
List first_n(NumericMatrix m, NumericVector v, int k);
RcppExport SEXP _tsfknn_first_n(SEXP mSEXP, SEXP vSEXP, SEXP kSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericMatrix >::type m(mSEXP);
    Rcpp::traits::input_parameter< NumericVector >::type v(vSEXP);
    Rcpp::traits::input_parameter< int >::type k(kSEXP);
    rcpp_result_gen = Rcpp::wrap(first_n(m, v, k));
    return rcpp_result_gen;
END_RCPP
}
// build_examples2
List build_examples2(NumericVector timeS, NumericVector lags, int nt);
RcppExport SEXP _tsfknn_build_examples2(SEXP timeSSEXP, SEXP lagsSEXP, SEXP ntSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericVector >::type timeS(timeSSEXP);
    Rcpp::traits::input_parameter< NumericVector >::type lags(lagsSEXP);
    Rcpp::traits::input_parameter< int >::type nt(ntSEXP);
    rcpp_result_gen = Rcpp::wrap(build_examples2(timeS, lags, nt));
    return rcpp_result_gen;
END_RCPP
}
// build_examples_m
List build_examples_m(NumericVector timeS, NumericVector lags, int nt);
RcppExport SEXP _tsfknn_build_examples_m(SEXP timeSSEXP, SEXP lagsSEXP, SEXP ntSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericVector >::type timeS(timeSSEXP);
    Rcpp::traits::input_parameter< NumericVector >::type lags(lagsSEXP);
    Rcpp::traits::input_parameter< int >::type nt(ntSEXP);
    rcpp_result_gen = Rcpp::wrap(build_examples_m(timeS, lags, nt));
    return rcpp_result_gen;
END_RCPP
}
// build_examples_a
List build_examples_a(NumericVector timeS, NumericVector lags, int nt);
RcppExport SEXP _tsfknn_build_examples_a(SEXP timeSSEXP, SEXP lagsSEXP, SEXP ntSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericVector >::type timeS(timeSSEXP);
    Rcpp::traits::input_parameter< NumericVector >::type lags(lagsSEXP);
    Rcpp::traits::input_parameter< int >::type nt(ntSEXP);
    rcpp_result_gen = Rcpp::wrap(build_examples_a(timeS, lags, nt));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_tsfknn_first_n", (DL_FUNC) &_tsfknn_first_n, 3},
    {"_tsfknn_build_examples2", (DL_FUNC) &_tsfknn_build_examples2, 3},
    {"_tsfknn_build_examples_m", (DL_FUNC) &_tsfknn_build_examples_m, 3},
    {"_tsfknn_build_examples_a", (DL_FUNC) &_tsfknn_build_examples_a, 3},
    {NULL, NULL, 0}
};

RcppExport void R_init_tsfknn(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
