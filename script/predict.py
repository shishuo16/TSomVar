from sklearn.ensemble import RandomForestClassifier
from sklearn.externals import joblib
import sys
import numpy as np

test_x = np.loadtxt(sys.argv[1])
mod1 = joblib.load(sys.argv[2] + "RF.pkl")
pred1 = mod1.predict(test_x) 
np.savetxt(sys.argv[3] +  ".result", pred1, fmt='%d')
pred_p = mod1.predict_proba(test_x) 
np.savetxt(sys.argv[3] +  ".result.prob", pred_p, fmt='%.04f')
