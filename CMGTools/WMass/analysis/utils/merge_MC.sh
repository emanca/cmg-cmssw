#!/bin/sh

echo "merging chunks (if they exist)"

samples=("DATA"   "WJetsPowPlus"  "WJetsPowNeg"  "WJetsMadSig"  "WJetsMadFake"  "DYJetsPow"  "DYJetsMadSig"  "DYJetsMadFake"   "TTJets"   "ZZJets"   "WWJets"  "WZJets"    "QCD"  "T_s"  "T_t"  "T_tW"  "Tbar_s"  "Tbar_t"  "Tbar_tW")
# analyses=("Wanalysis" "Zanalysis" "PhiStarEtaAnalysis")
analyses=("Wanalysis" "Zanalysis" )

for (( id_sample=0; id_sample<${#samples[@]}; id_sample++ ))
  do
  for (( id_ana=0; id_ana<${#analyses[@]}; id_ana++ ))
    do
    
    nchunks=$(ls ${1}/test_numbers_${samples[id_sample]}/${analyses[id_ana]}_chunk*.root |wc -l)
    nchunks_planned=$(more ${1}/test_numbers_${samples[id_sample]}/${analyses[id_ana]}_nChuncks.log)
    if [ $nchunks -gt 0 ]
    then
      if [ $nchunks -ne $nchunks_planned ]
      then
        echo "MISSING "${analyses[id_ana]}" chunk for "${samples[id_sample]}": nchunks="${nchunks}" nchunks_planned="${nchunks_planned}"!!! EXITING"
        exit 1
        # continue
      fi
      hadd -f ${1}/test_numbers_${samples[id_sample]}/${analyses[id_ana]}OnDATA.root ${1}/test_numbers_${samples[id_sample]}/${analyses[id_ana]}_chunk*.root 
      rm ${1}/test_numbers_${samples[id_sample]}/${analyses[id_ana]}_chunk*.root 
      rm -rf ${1}/test_numbers_${samples[id_sample]}/LSFJOB_*
      rm -rf ${1}/test_numbers_${samples[id_sample]}/*.out
    fi
    
  done
done

echo 'EWK ONLY (EWK)'
# EWK ONLY
mkdir ${1}/test_numbers_EWK
echo 'Z analysis (W+Jets sig+fake, DY+Jets fake, ZZ, WZ, WW)'
hadd -f ${1}/test_numbers_EWK/ZanalysisOnDATA.root ${1}/test_numbers_WJetsMadFake/ZanalysisOnDATA.root ${1}/test_numbers_DYJetsMadFake/ZanalysisOnDATA.root ${1}/test_numbers_ZZJets/ZanalysisOnDATA.root ${1}/test_numbers_WZJets/ZanalysisOnDATA.root ${1}/test_numbers_WWJets/ZanalysisOnDATA.root 
echo 'W analysis (W+Jets fake, DY+Jets sig+fake, ZZ, WZ, WW)'
hadd -f ${1}/test_numbers_EWK/WanalysisOnDATA.root ${1}/test_numbers_WJetsMadFake/WanalysisOnDATA.root ${1}/test_numbers_DYJetsMadFake/WanalysisOnDATA.root ${1}/test_numbers_ZZJets/WanalysisOnDATA.root ${1}/test_numbers_WZJets/WanalysisOnDATA.root ${1}/test_numbers_WWJets/WanalysisOnDATA.root 

echo 'EWK + TT + Single Top (EWKTT)'
# EWK + TT
mkdir ${1}/test_numbers_EWKTT
echo 'Z analysis'
hadd -f ${1}/test_numbers_EWKTT/ZanalysisOnDATA.root ${1}/test_numbers_EWK/ZanalysisOnDATA.root ${1}/test_numbers_TTJets/ZanalysisOnDATA.root ${1}/test_numbers_T_s/ZanalysisOnDATA.root ${1}/test_numbers_T_t/ZanalysisOnDATA.root ${1}/test_numbers_T_tW/ZanalysisOnDATA.root ${1}/test_numbers_Tbar_s/ZanalysisOnDATA.root ${1}/test_numbers_Tbar_t/ZanalysisOnDATA.root ${1}/test_numbers_Tbar_tW/ZanalysisOnDATA.root
echo 'W analysis'
hadd -f ${1}/test_numbers_EWKTT/WanalysisOnDATA.root ${1}/test_numbers_EWK/WanalysisOnDATA.root ${1}/test_numbers_TTJets/WanalysisOnDATA.root ${1}/test_numbers_T_s/WanalysisOnDATA.root ${1}/test_numbers_T_t/WanalysisOnDATA.root ${1}/test_numbers_T_tW/WanalysisOnDATA.root ${1}/test_numbers_Tbar_s/WanalysisOnDATA.root ${1}/test_numbers_Tbar_t/WanalysisOnDATA.root ${1}/test_numbers_Tbar_tW/WanalysisOnDATA.root

echo 'EWK + TT + Single Top + SIG POWHEG (MCDATALIKEPOW)'
# EWK + TT + SIG
mkdir ${1}/test_numbers_MCDATALIKEPOW
echo 'Z analysis'
hadd -f ${1}/test_numbers_MCDATALIKEPOW/ZanalysisOnDATA.root ${1}/test_numbers_EWKTT/ZanalysisOnDATA.root ${1}/test_numbers_DYJetsPow/ZanalysisOnDATA.root
echo 'W analysis'
hadd -f ${1}/test_numbers_MCDATALIKEPOW/WanalysisOnDATA.root ${1}/test_numbers_EWKTT/WanalysisOnDATA.root ${1}/test_numbers_WJetsPowPlus/WanalysisOnDATA.root ${1}/test_numbers_WJetsPowNeg/WanalysisOnDATA.root

echo 'EWK + TT + Single Top + SIG MADGRAPH (MCDATALIKEMAD)'
# EWK + TT + SIG
mkdir ${1}/test_numbers_MCDATALIKEMAD
echo 'Z analysis'
hadd -f ${1}/test_numbers_MCDATALIKEMAD/ZanalysisOnDATA.root ${1}/test_numbers_EWKTT/ZanalysisOnDATA.root ${1}/test_numbers_DYJetsMadSig/ZanalysisOnDATA.root
echo 'W analysis'
hadd -f ${1}/test_numbers_MCDATALIKEMAD/WanalysisOnDATA.root ${1}/test_numbers_EWKTT/WanalysisOnDATA.root ${1}/test_numbers_WJetsMadSig/WanalysisOnDATA.root

