//Create dataset to save model results into
clear
set obs 1
gen exp = ""
save "adj_rr_vac1.dta", replace

//Loop to run modified Poisson regressiom model for each mental health exposure (included in analysis population dataset) and save model results
use "vac1_analysis_pop.dta", clear
foreach mend in any alcohol anxiety depression psychotic stress substance tobacco antidepres antipsych anxiolytic hypnotic anymeds {
	use "vac1_analysis_pop.dta", clear
	poisson vac1 `mend' i.sex age i.incomec i.cohabc sev_covid i.regionc i.educationc cci, irr vce(robust)
	matrix b = r(table)
    clear
    set obs 1
    gen exp = "`mend'"
    gen adj_rr = b[1,1]
    gen adj_lci = b[5,1]
    gen adj_uci = b[6,1]
    gen adj_p = b[4,1]
	append using "adj_rr_vac1.dta"
	save "adj_rr_vac1.dta", replace
}

**Loop can then then be repeated with the dose 2 vaccination outcome**
