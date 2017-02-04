# --------------------------------------------------
# 3D Model of Calvi et al. [2002] 3 Storey RC Frame
# --------------------------------------------------
# Copyright by Gerard J. O'Reilly
# IUSS Pavia, Italy
# February 2017
# --------------------------------------
#
# References:
# Calvi, G. M., Magenes, G., Pampanin, S. [2002] “Experimental Test on a
# Three Storey RC Frame Designed for Gravity Only,” 12th European
# Conference on Earthquake Engineering, London, UK.
#
# O’Reilly, G. J. [2016] “Performance-Based Seismic Assessment and Retrofit
# of Existing RC Frame Buildings in Italy,” PhD Thesis, IUSS Pavia, Italy.

wipe; # Before starting anything, wipe everything

#  Create a directory to which all of the output from this model will be put.
set outsdir opensees_output
file mkdir $outsdir

# --------------------------------------
# Define the model
# --------------------------------------
#  Depsite the test fram being a 2D setup, we will use a 3D model in any case
#  since more elaborate examples will more than likely be 3D.
model basic -ndm 3 -ndf 6

# --------------------------------------
# Load some scripts
# --------------------------------------
source Units.tcl
source rcBC_nonDuct.tcl
source cyclicPush.tcl
source jointModel.tcl

# --------------------------------------
# Define some basic model parameters
# --------------------------------------
# Dimesions (See Calvi et al. [2002] for details)
set hc	[expr 200*$mm];	# Column section height
set bc	[expr 200*$mm];	# Column section width
set hb	[expr 330*$mm];	# Beam section height
set bb	[expr 200*$mm];	# Beam section width
set sb	[expr 115*$mm];	# Beam stirrup spacing
set sc	[expr 135*$mm];	# Column stirrup spacing
set cv 	[expr 20*$mm];	# Concrete cover
set H 	[expr 2.0*$m];	# Floor height
set dbeam 	[expr 301*$mm];	# Beam section depth
set dcolumn [expr 172*$mm];	# Column section depth
set dbL 	[expr 10*$mm];	# Diameter of lognitudinal reinforcement bars
set dbV 	[expr 4*$mm];	# Diameter of transverse reinforcement bars

# Material Properties (See Calvi et al. [2002] for details)
set fcb1 	13.28;	# fc of beam concrete on first floor (in MPa)
set fcb2 	13.84;	# fc of beam concrete on second floor (in MPa)
set fcb3 	12.72;	# fc of beam concrete on third floor (in MPa)
set Ecb1 	[expr 3320*sqrt($fcb1)+6900];	# Elastic modulus of beam concrete on first floor (in MPa)
set Ecb2 	[expr 3320*sqrt($fcb2)+6900]; # Elastic modulus of beam concrete on second floor (in MPa)
set Ecb3 	[expr 3320*sqrt($fcb3)+6900]; # Elastic modulus of beam concrete on third floor (in MPa)
set fcc1 	17.06;	# fc of column concrete on first floor (in MPa)
set fcc2 	13.19;	# fc of column concrete on second floor (in MPa)
set fcc3 	13.47;	# fc of column concrete on third floor (in MPa)
set Ecc1 	[expr 3320*sqrt($fcc1)+6900];	# Elastic modulus of column concrete on first floor (in MPa)
set Ecc2 	[expr 3320*sqrt($fcc2)+6900];	# Elastic modulus of column concrete on second floor (in MPa)
set Ecc3 	[expr 3320*sqrt($fcc3)+6900];	# Elastic modulus of column concrete on third floor (in MPa)
set fyL	345.9;	# Yield strength (in MPa) of longitudinal reinforcement bars
set fuL	458.6;	# Ultimate strength (in MPa) of longitudinal reinforcement bars
set fyV	385.6;	# Yield strength (in MPa) of transverse reinforcement bars
set fuV	451.9;	# Ultimate strength (in MPa) of transverse reinforcement bars
set Es 	200e3;	# Elastic modulus of steel (in MPa)

# Reinforcement ratios (These are computed based on the reinforcement provided at each plascti hige zone)
set rC_top 0.0043836176561718; 	set rC_web 0; 	set rC_bot 0.0043836176561718; 	set rC_shr 0.000930842267730309;	# Column
set rB1_top 0.00542912215581993; 	set rB1_web 0; 	set rB1_bot 0.00542912215581993; 	set rB1_shr 0.00109272787950949;	# Beam Section 1
set rB3_top 0.00730498482849603; 	set rB3_web 0; 	set rB3_bot 0.00166971081794195; 	set rB3_shr 0.00109272787950949;	# Beam Section 2
set rB5_top 0.00542656015831134; 	set rB5_web 0; 	set rB5_bot 0.00354813548812665; 	set rB5_shr 0.00109272787950949;	# Beam Section 5

# Joint Properties (See O'Reilly [2016] for experimental calibration of various coefficients)
set k_cr_int 	0.29;		set k_pk_int 	0.42;		set k_ult_int 	0.42; 	# Interior beam-column joints principle tensile stress coefficients (kappa)
set k_cr_ext 	0.132; 	set k_pk_ext 	0.132;	set k_ult_ext 	0.053;	# Exterior beam-column joints principle tensile stress coefficients (kappa)
set gamm_cr		0.0002;	set gamm_pk		0.0132;	set gamm_ult	0.0270;	# Beam-column joint shear deformations (gamma)
set ptc_int 	[list $k_cr_int $k_pk_int $k_ult_int $k_cr_int $k_pk_int $k_ult_int];
set ptc_ext 	[list $k_cr_ext $k_pk_ext $k_ult_ext $k_cr_ext $k_pk_ext $k_ult_ext];
set gamm_ext 	[list $gamm_cr $gamm_pk $gamm_ult $gamm_cr $gamm_pk $gamm_ult];
set gamm_int 	[list $gamm_cr $gamm_pk $gamm_ult $gamm_cr $gamm_pk $gamm_ult];
set hyst_ext 	[list 0.6 0.2 0.0 0.0 0.3];
set hyst_int 	[list 0.6 0.2 0.0 0.010 0.3];
set hyst_rof 	[list 0.6 0.2 0.0 0.0 0.3];
set c_c1 		[list $fcc1 $Ecc1 $cv];
set c_c2 		[list $fcc2 $Ecc2 $cv];
set c_c3 		[list $fcc3 $Ecc3 $cv];
set brs 		[list $dbL $dbV]; 		# bars		Bar dias (dbL dbV) m
set col 		[list $hc $bc]; 			# (hcX hcY) m
set bm 		[list $hb $hb $bb $bb]; 	# (hbX hbY bbX bbY) m

# --------------------------------------
# Define the base nodes
# --------------------------------------
# node 	tag 	X		Y		Z
node	1110		0.0		0.0		0.0 -mass 0.0 0.0 0.0 0.0 0.0 0.0
node	1210		3.0		0.0		0.0 -mass 0.0 0.0 0.0 0.0 0.0 0.0
node	1310		4.33		0.0		0.0 -mass 0.0 0.0 0.0 0.0 0.0 0.0
node	1410		6.66		0.0		0.0 -mass 0.0 0.0 0.0 0.0 0.0 0.0

# --------------------------------------
# Define Transformations
# --------------------------------------
# Use P-Delta geometric transformations. Include rigid-end offsets to account for the rigid zones of the beam-column joints.
# These are incorporated here as opposed to inserting rigid members at each joint for computational efficiency.
geomTransf PDelta 	1  0 1 0 -jntOffset [expr $hc/2] 0.0 0.0 [expr -$hc/2] 0.0 0.0; # z is in Y
geomTransf PDelta 	2  0 1 0 -jntOffset  0.0 0.0 [expr $hb/2] 0.0 0.0 [expr -$hb/2]; # z is in Y
set GTb	1;
set GTc 	2;
# --------------------------------------
# Define Elements
# --------------------------------------
# Open a set of files so that the properties of the beams, columns and joint elements creted using the provided procedures can be examined later.
set pfile_jnts [open $outsdir/Properties_joints.txt w];
set pfile_bms [open $outsdir/Properties_beams.txt w];
set pfile_cols [open $outsdir/Properties_columnn.txt w];

# Joints
# jointModel $jtype     $index $XYZ 		  $M   $col $bm $conc $bars $P   $H $ptc     $gamm     $hyst     $pfile 	{pflag 0}
jointModel 	 "Exterior"	111 	[list 0.00 0.0 2.0] 1.62 $col $bm $c_c1 $brs  43.0 $H $ptc_ext $gamm_ext $hyst_ext $pfile_jnts
jointModel 	 "Interior"	211 	[list 3.00 0.0 2.0] 2.34 $col $bm $c_c1 $brs  61.8 $H $ptc_int $gamm_int $hyst_int $pfile_jnts
jointModel 	 "Interior"	311 	[list 4.33 0.0 2.0] 2.10 $col $bm $c_c1 $brs  57.1 $H $ptc_int $gamm_int $hyst_int $pfile_jnts
jointModel 	 "Exterior"	411 	[list 6.66 0.0 2.0] 1.38 $col $bm $c_c1 $brs  38.3 $H $ptc_ext $gamm_ext $hyst_ext $pfile_jnts

jointModel 	 "Exterior"	112 	[list 0.00 0.0 4.0] 1.62 $col $bm $c_c2 $brs  27.1 $H $ptc_ext $gamm_ext $hyst_ext $pfile_jnts
jointModel 	 "Interior"	212 	[list 3.00 0.0 4.0] 2.34 $col $bm $c_c2 $brs  38.9 $H $ptc_int $gamm_int $hyst_int $pfile_jnts
jointModel 	 "Interior"	312 	[list 4.33 0.0 4.0] 2.10 $col $bm $c_c2 $brs  36.5 $H $ptc_int $gamm_int $hyst_int $pfile_jnts
jointModel 	 "Exterior"	412 	[list 6.66 0.0 4.0] 1.38 $col $bm $c_c2 $brs  24.8 $H $ptc_ext $gamm_ext $hyst_ext $pfile_jnts

jointModel 	 "Exterior"	113 	[list 0.00 0.0 6.0] 1.14 $col $bm $c_c3 $brs  11.2 $H $ptc_ext $gamm_ext $hyst_ext $pfile_jnts
jointModel 	 "Interior"	213 	[list 3.00 0.0 6.0] 1.62 $col $bm $c_c3 $brs  15.9 $H $ptc_int $gamm_int $hyst_int $pfile_jnts
jointModel 	 "Interior"	313 	[list 4.33 0.0 6.0] 1.62 $col $bm $c_c3 $brs  15.9 $H $ptc_int $gamm_int $hyst_int $pfile_jnts
jointModel 	 "Exterior"	413 	[list 6.66 0.0 6.0] 1.14 $col $bm $c_c3 $brs  11.2 $H $ptc_ext $gamm_ext $hyst_ext $pfile_jnts

# Beams
# rcBC_nonDuct $ST $ET $GT $iNode $jNode $fyL $fyV $Es $fc   $Ec   $b  $h  $s  $cv $dbL  $dbV $P  $Ls    $rho_shr   $rho_top1zz $rho_mid1zz $rho_bot1zz $rho_top2zz $rho_mid2zz $rho_bot2zz $rho_top1yy $rho_mid1yy $rho_bot1yy $rho_top2yy $rho_mid2yy $rho_bot2yy $pfile {pflag 0}
rcBC_nonDuct   0 	5111 $GTb  6111 6211 $fyL $fyV $Es $fcb1 $Ecb1 $bb $hb $sb $cv $dbL  $dbV 0.0 1.500  $rB1_shr   $rB1_top    $rB1_web 	$rB1_bot    $rB1_top    $rB1_web 	$rB1_bot    $rB1_top    $rB1_web 	$rB1_bot    $rB1_top    $rB1_web 	$rB1_bot    $pfile_bms
rcBC_nonDuct   0 	5211 $GTb  6211 6311 $fyL $fyV $Es $fcb1 $Ecb1 $bb $hb $sb $cv $dbL  $dbV 0.0 0.665  $rB3_shr   $rB3_top    $rB3_web 	$rB3_bot    $rB3_top    $rB3_web 	$rB3_bot    $rB3_top    $rB3_web 	$rB3_bot    $rB3_top    $rB3_web 	$rB3_bot    $pfile_bms
rcBC_nonDuct   0 	5311 $GTb  6311 6411 $fyL $fyV $Es $fcb1 $Ecb1 $bb $hb $sb $cv $dbL  $dbV 0.0 1.665  $rB5_shr   $rB5_top    $rB5_web 	$rB5_bot    $rB5_top    $rB5_web 	$rB5_bot    $rB5_top    $rB5_web 	$rB5_bot    $rB5_top    $rB5_web 	$rB5_bot    $pfile_bms

rcBC_nonDuct   0 	5112 $GTb  6112 6212 $fyL $fyV $Es $fcb2 $Ecb2 $bb $hb $sb $cv $dbL  $dbV 0.0 1.500  $rB1_shr   $rB1_top    $rB1_web 	$rB1_bot    $rB1_top    $rB1_web 	$rB1_bot    $rB1_top    $rB1_web 	$rB1_bot    $rB1_top    $rB1_web 	$rB1_bot    $pfile_bms
rcBC_nonDuct   0 	5212 $GTb  6212 6312 $fyL $fyV $Es $fcb2 $Ecb2 $bb $hb $sb $cv $dbL  $dbV 0.0 0.665  $rB3_shr   $rB3_top    $rB3_web 	$rB3_bot    $rB3_top    $rB3_web 	$rB3_bot    $rB3_top    $rB3_web 	$rB3_bot    $rB3_top    $rB3_web 	$rB3_bot    $pfile_bms
rcBC_nonDuct   0 	5312 $GTb  6312 6412 $fyL $fyV $Es $fcb2 $Ecb2 $bb $hb $sb $cv $dbL  $dbV 0.0 1.665  $rB5_shr   $rB5_top    $rB5_web 	$rB5_bot    $rB5_top    $rB5_web 	$rB5_bot    $rB5_top    $rB5_web 	$rB5_bot    $rB5_top    $rB5_web 	$rB5_bot    $pfile_bms

rcBC_nonDuct   0 	5113 $GTb  6113 6213 $fyL $fyV $Es $fcb3 $Ecb3 $bb $hb $sb $cv $dbL  $dbV 0.0 1.500  $rB1_shr   $rB1_top    $rB1_web 	$rB1_bot    $rB1_top    $rB1_web 	$rB1_bot    $rB1_top    $rB1_web 	$rB1_bot    $rB1_top    $rB1_web 	$rB1_bot    $pfile_bms
rcBC_nonDuct   0 	5213 $GTb  6213 6313 $fyL $fyV $Es $fcb3 $Ecb3 $bb $hb $sb $cv $dbL  $dbV 0.0 0.665  $rB3_shr   $rB3_top    $rB3_web 	$rB3_bot    $rB3_top    $rB3_web 	$rB3_bot    $rB3_top    $rB3_web 	$rB3_bot    $rB3_top    $rB3_web 	$rB3_bot    $pfile_bms
rcBC_nonDuct   0 	5313 $GTb  6313 6413 $fyL $fyV $Es $fcb3 $Ecb3 $bb $hb $sb $cv $dbL  $dbV 0.0 1.665  $rB5_shr   $rB5_top    $rB5_web 	$rB5_bot    $rB5_top    $rB5_web 	$rB5_bot    $rB5_top    $rB5_web 	$rB5_bot    $rB5_top    $rB5_web 	$rB5_bot    $pfile_bms

# Columns
# rcBC_nonDuct $ST $ET   $GT $iNode $jNode $fyL $fyV $Es $fc   $Ec   $b  $h  $s  $cv $dbL  $dbV $P    $Ls    $rho_shr   $rho_top1zz $rho_mid1zz $rho_bot1zz $rho_top2zz $rho_mid2zz $rho_bot2zz $rho_top1yy $rho_mid1yy $rho_bot1yy $rho_top2yy $rho_mid2yy $rho_bot2yy $pfile {pflag 0}
rcBC_nonDuct   1   7111  $GTc 1110 	1111   $fyL $fyV $Es $fcc1 $Ecc1 $bc $hc $sc $cv $dbL  $dbV 43.0  1.00   $rC_shr    $rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$pfile_cols
rcBC_nonDuct   1   7211  $GTc 1210 	1211   $fyL $fyV $Es $fcc1 $Ecc1 $bc $hc $sc $cv $dbL  $dbV 61.8  1.00   $rC_shr    $rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$pfile_cols
rcBC_nonDuct   1   7311  $GTc 1310 	1311   $fyL $fyV $Es $fcc1 $Ecc1 $bc $hc $sc $cv $dbL  $dbV 57.1  1.00   $rC_shr    $rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$pfile_cols
rcBC_nonDuct   1   7411  $GTc 1410 	1411   $fyL $fyV $Es $fcc1 $Ecc1 $bc $hc $sc $cv $dbL  $dbV 38.3  1.00   $rC_shr    $rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$pfile_cols

rcBC_nonDuct   1   7112  $GTc 1111 	1112   $fyL $fyV $Es $fcc2 $Ecc2 $bc $hc $sc $cv $dbL  $dbV 27.1  1.00   $rC_shr    $rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$pfile_cols
rcBC_nonDuct   1   7212  $GTc 1211 	1212   $fyL $fyV $Es $fcc2 $Ecc2 $bc $hc $sc $cv $dbL  $dbV 38.9  1.00   $rC_shr    $rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$pfile_cols
rcBC_nonDuct   1   7312  $GTc 1311 	1312   $fyL $fyV $Es $fcc2 $Ecc2 $bc $hc $sc $cv $dbL  $dbV 36.5  1.00   $rC_shr    $rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$pfile_cols
rcBC_nonDuct   1   7412  $GTc 1411 	1412   $fyL $fyV $Es $fcc2 $Ecc2 $bc $hc $sc $cv $dbL  $dbV 24.8  1.00   $rC_shr    $rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$pfile_cols

rcBC_nonDuct   1   7113  $GTc 1112 	1113   $fyL $fyV $Es $fcc3 $Ecc3 $bc $hc $sc $cv $dbL  $dbV 11.2  1.00   $rC_shr    $rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$pfile_cols
rcBC_nonDuct   1   7213  $GTc 1212 	1213   $fyL $fyV $Es $fcc3 $Ecc3 $bc $hc $sc $cv $dbL  $dbV 15.9  1.00   $rC_shr    $rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$pfile_cols
rcBC_nonDuct   1   7313  $GTc 1312 	1313   $fyL $fyV $Es $fcc3 $Ecc3 $bc $hc $sc $cv $dbL  $dbV 15.9  1.00   $rC_shr    $rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$pfile_cols
rcBC_nonDuct   1   7413  $GTc 1412 	1413   $fyL $fyV $Es $fcc3 $Ecc3 $bc $hc $sc $cv $dbL  $dbV 11.2  1.00   $rC_shr    $rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$rC_top 	$rC_web 	$rC_bot 	$pfile_cols

puts "Elements created"
# Close the properties files
close $pfile_jnts
close $pfile_bms
close $pfile_cols
# --------------------------------------
# Boundary Conditions
# --------------------------------------
# Base Supports
# fix node	dX dY dZ rX rY rZ
fix 	1110	1  1  1  1  1  1
fix 	1210	1  1  1  1  1  1
fix 	1310	1  1  1  1  1  1
fix 	1410	1  1  1  1  1  1

# OOP Support at the Connections
# fix node	dX dY dZ rX rY rZ
fix 	1111	0  1  0  0  0  0
fix 	1211	0  1  0  0  0  0
fix 	1311	0  1  0  0  0  0
fix 	1411	0  1  0  0  0  0
fix 	1112	0  1  0  0  0  0
fix 	1212	0  1  0  0  0  0
fix 	1312	0  1  0  0  0  0
fix 	1412	0  1  0  0  0  0
fix 	1113	0  1  0  0  0  0
fix 	1213	0  1  0  0  0  0
fix 	1313	0  1  0  0  0  0
fix 	1413	0  1  0  0  0  0
# --------------------------------------
# Print the model file (Useful for plotting)
# --------------------------------------
file delete $outsdir/model.txt
print $outsdir/model.txt
# --------------------------------------
# Apply gravity loading
# --------------------------------------
pattern Plain 101 Constant {
	#    node	x	y	z		rx	ry	rz
	load 1111 	0.0	0.0	-15.90	0.0	0.0	0.0
	load 1211 	0.0	0.0	-22.95	0.0	0.0	0.0
	load 1311 	0.0	0.0	-20.60	0.0	0.0	0.0
	load 1411 	0.0	0.0	-13.55	0.0	0.0	0.0

	load 1112 	0.0	0.0	-15.90	0.0	0.0	0.0
	load 1212 	0.0	0.0	-22.95	0.0	0.0	0.0
	load 1312 	0.0	0.0	-20.60	0.0	0.0	0.0
	load 1412 	0.0	0.0	-13.55	0.0	0.0	0.0

	load 1113 	0.0	0.0	-11.20	0.0	0.0	0.0
	load 1213 	0.0	0.0	-15.90	0.0	0.0	0.0
	load 1313 	0.0	0.0	-15.90	0.0	0.0	0.0
	load 1413 	0.0	0.0	-11.20	0.0	0.0	0.0
}

constraints Plain
numberer 	Plain
system 	UmfPack
test 		EnergyIncr	1e-6 100
algorithm 	Newton
integrator 	LoadControl 0.01
analysis 	Static
analyze 	100

# maintain constant gravity loads and reset time to zero
loadConst -time 0.0
puts "Gravity analysis completed"
# --------------------------------------
# Lateral loading
# --------------------------------------
pattern Plain 1 Linear -factor 1 {
	#	 node	x				y	z		rx	ry	rz
	load 1111	[expr 0.45/(0.45+0.90+1.0)] 0.0 0.0 0.0 0.0 0.0
	load 1112	[expr 0.90/(0.45+0.90+1.0)] 0.0 0.0 0.0 0.0 0.0
	load 1113	[expr 1.00/(0.45+0.90+1.0)] 0.0 0.0 0.0 0.0 0.0
}
puts "Lateral loading applied"

# --------------------------------------
# Define recorders
# --------------------------------------
# Nodes
recorder Node		-file $outsdir/displacement.txt 	-node 1111 1112 1113 -dof 1 disp
recorder Node		-file $outsdir/reaction.txt 		-node 1110 1210 1310 1410 -dof 1 reaction
# # Hinges
# recorder Element	-file $outsdir/joint_forces.txt 	-ele 9113 9213 9313 9413 9112 9212 9312 9412 9111 9211 9311 9411 force
# recorder Element	-file $outsdir/joint_deformations.txt 	-ele 9113 9213 9313 9413 9112 9212 9312 9412 9111 9211 9311 9411 deformation
# # Beams
# recorder Element 	-file $outsdir/beam_section_forces.txt -ele 5113 5213 5313 5112 5212 5312 5111 5211 5311 section force
# recorder Element 	-file $outsdir/beam_section_deformations.txt -ele 5113 5213 5313 5112 5212 5312 5111 5211 5311 section deformation
# # Columns
# recorder Element 	-file $outsdir/column_section_forces.txt -ele 7113 7213 7313 7413 7112 7212 7312 7412 7111 7211 7311 7411 section force
# recorder Element 	-file $outsdir/column_section_deformations.txt -ele 7113 7213 7313 7413 7112 7212 7312 7412 7111 7211 7311 7411 section deformation

# --------------------------------------
# ANALYSIS OBJECTS
# --------------------------------------
# Perform the cyclic pushover analysis
constraints 	Plain
numberer 		Plain
system 		UmfPack
set dref 0.001
set ctrlN 1113
set drn 1
set nSteps 500
#cyclicPush $dref mu nCyc 	ctrlN  drn  nSteps pflag
cyclicPush $dref 12   3 	$ctrlN $drn $nSteps 1 0
cyclicPush $dref 36   3 	$ctrlN $drn $nSteps 1 0
cyclicPush $dref 72   3 	$ctrlN $drn $nSteps 1 0
cyclicPush $dref 96   1		$ctrlN $drn $nSteps 1 0

wipe; # wipe so that last line of recorders will be printed and OpenSees will finish outputting to them
