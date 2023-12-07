import 'dart:math';

class InternalMath {
  List calc(var rpm, pressureIntake, tempIntake, vs, km) {
    double densityGasoline = 737; // Density of gasoline 737g/L -> 7,37g/L
    int densityDiesel = 850; // Density of diesel 737g/L
    int densityEthanol = 789; // Density of ethanol 737g/L

    double co2PerGasoline =
        2310; // co2 per liter of gasoline g/L 2310 -> 23,10
    int co2PerDiesel = 2660; // co2 per liter of diesel g/L
    int co2PerEthanol = 1519; // co2 per liter of ethanol g/L

    double afrGasoline = 14.7; // AFR constant for gasoline
    double afrDiesel = 14.6; // AFR constant for diesel
    double afrEthanol = 9.1; // AFR constant for ethanol
//3924/33957
    //Vintake represents the real volume of intake air supported by the cylinders.
    int Vintake = 400;

    //Vnominal is the theoretical volume of the engine.
    int Vnominal = 500;

    double massAir = 28.96; //massa molar do ar

    //Equation (12)
    //On the article the value volumetric eficiency
    double volumetricEfficiency = 0.8;

    //the volume of the combustion chambers in the engine cylinders
    int V = 50;
    //the ideal gas constant J/ (mol*k)
    double R = 8.3145;

    //Pressure_intake represents the pressure in the combustion chamber and can be obtained by means of the MAP (Manifold Absolute Pressure) sensor in KPa.
    //Temp_intake T is the gas temperature. It can be obtained by the IAT (Intake Absolute Temperature) sensor in K.
    double fImap = rpm * (pressureIntake / tempIntake / 2);
    double massOfAirFlow2 =
        fImap * volumetricEfficiency * 1.984 * 28.97 / 8.314;

    //Equation (14)
    //double massOfAirFlow = ((pressure_intake * V) / (1000 * R * temp_intake)) * (mass_air * volumetric_efficiency * rpm / 120);
    double massOfAirFlow = (pressureIntake * V / (1000 * R * tempIntake)) *
        (massAir * volumetricEfficiency * rpm / 120);

    double fuelflow1 =
        ((massOfAirFlow * 3600) / (afrGasoline * densityGasoline)) /
            10; //[l/h]

    double sfc = vs / (massOfAirFlow / afrGasoline);
//4284
//214.782889

//https://stackoverflow.com/questions/17170646/what-is-the-best-way-to-get-fuel-consumption-mpg-using-obd2-parameters
    //double fuel_Consuption = (sfc) * (1 / 2.7);

    double fuelConsuption2 =
        (massOfAirFlow / afrGasoline * densityGasoline) / vs;

    double fuelConsuption3 = (fuelflow1) / vs;

    //print('mass');
    //   print([
    //    massOfAirFlow,
    //    vs,
    //   fuelflow1,
    //   fuel_Consuption2,
    //  fuel_Consuption3,
    //  sfc
    //  ]);

    //Equation (6)
    double massCo2 =
        massOfAirFlow / (afrGasoline * densityGasoline) * co2PerGasoline;

    //double gasoline = (7.718 * vs / massOfAirFlow) * 0.425144;

    //print([massOfAirFlow, vs, fuel_Consuption3]);

    return [massCo2, fuelConsuption3];
  }

  //Linear interpolation
  List regressionLinear1(List a, List b) {
    List c = [];

    double acca = a.reduce((a, b) => a + b);
    double accb = b.reduce((a, b) => a + b);
    double meanA = acca / a.length;
    double meanB = accb / b.length;
    List helpa = [], helpb = [];

    //print(a.length);
    //print(b.length);

    for (int i = 0; i < b.length - 1; i++) {
      helpa.add(a[i] - meanA);
      helpb.add(b[i] - meanB);
    }

    for (int i = 0; i < b.length - 1; i++) {
      acca += (helpa[i] * helpa[i]);
      accb += (helpa[i] * helpb[i]);
    }

    double m = accb / acca;
    double cc = meanB - (m * meanA);

    for (int i = 0; i < b.length - 1; i++) {
      c.add((m * a[i]) + cc);
    }
    double acc = 0;
    List accarr = [];

    for (int i = 0; i < b.length - 1; i++) {
      if (b[i] == -1) {
        b[i] = c[i];
      }
      acc += a[i];
      accarr.add(acc);
    }

    return [b, acc, accarr];
  }

  List regressionLinear2(List a, List b) {
    List c = [];

    double acca = a.reduce((a, b) => a + b);
    double accb = b.reduce((a, b) => a + b);
    double meanA = acca / a.length;
    double meanB = accb / b.length;
    List helpa = [], helpb = [];

    for (int i = 0; i <= b.length - 1; i++) {
      helpa.add(a[i] - meanA);
      helpb.add(b[i] - meanB);
    }

    for (int i = 0; i <= b.length - 1; i++) {
      acca += (helpa[i] * helpa[i]);
      accb += (helpa[i] * helpb[i]);
    }

    double m = accb / acca;
    double cc = meanB - (m * meanA);

    for (int i = 0; i < a.length; i++) {
      c.add((m * a[i]) + cc);
    }

    for (int i = 0; i < a.length; i++) {
      acca = acca + ((c[i] - meanB) * (c[i] - meanB));
    }

    for (int i = 0; i < b.length - 1; i++) {
      accb = accb + ((b[i] - meanB) * (b[i] - meanB));
    }

    double R = 1 - (acca / accb);

    return [c, m, cc, R];
  }

  //669
  //entender e programar
  List four1(List data, int n, int sinal) {
    int nn, mmax, m, j, istep, i;

    double wtemp, wr, wpr, wpi, wi, theta, tempr, tempi;
    if (n < 2 || n & (n - 1) == 0) throw ("n must be power of 2 in four1");
    nn = n << 1 - 1;

    j = 1;
    for (i = 1; i <= nn; i += 2) {
      if (j > i) {
        var help = data[j - 1];
        data[j - 1] = data[i - 1];
        data[i - 1] = help;

        help = data[j];
        data[j] = data[i];
        data[i] = help;
      }

      m = n;

      while (m >= 2 && j > m) {
        j -= m;

        m >> 1;
      }

      j += m;
    }

    mmax = 2;
    while (nn > mmax) {
      istep = mmax << 1;
      theta = sinal * (6.28318530717959 / mmax);
      wtemp = sin(0.5 * theta);
      wpr = -2.0 * wtemp * wtemp;
      wpi = sin(theta);
      wr = 1.0;
      wi = 0.0;
      for (m = 1; m < mmax; m += 2) {
        for (i = m; i <= nn; i += istep) {
          j = i + mmax;

          tempr = wr * data[j - 1] - wi * data[j];
          tempi = wr * data[j] + wi * data[j - 1];
          data[j - 1] = data[i - 1] - tempr;
          data[j] = data[i] - tempi;
          data[i - 1] += tempr;
          data[i] += tempi;
        }
        wr = (wtemp = wr) * wpr - wi * wpi + wr;
        wi = wi * wpr + wtemp * wpi + wi;
      }
      mmax = istep;
    }

    return data;
  }

  void realft(List data, int sinal) {
    int i, i1, i2, i3, i4, n = data.length - 1;
    double c1 = 0.5, c2, h1r, h1i, h2r, h2i, wr, wi, wpr, wpi, wtemp;
    double theta = 3.141592653589793238 / (n >> 1).toDouble();
    List data2 = List.filled(data.length * 2 - 1, 0.0);
    for (int i = 0; i < data.length; i++) {
      data2[i] = data[i];
    }

    if (sinal == 1) {
      c2 = -0.5;

      if (data.length != n & (n - 1)) {
        data2 = four1(data2, data.length - 1, 1);
      } else {
        data2 = four1(data2, data.length, 1);
      }
    } else {
      c2 = 0.5;
      theta = -theta;
    }
    wtemp = sin(0.5 * theta);
    wpr = -2.0 * wtemp * wtemp;
    wpi = sin(theta);
    wr = 1.0 + wpr;
    wi = wpi;
    for (i = 1; i < (n >> 2); i++) {
      i2 = 1 + (i1 = i + i);
      i4 = 1 + (i3 = n - i1);
      h1r = c1 * (data[i1] + data[i3]);
      h1i = c1 * (data[i2] - data[i4]);
      h2r = -c2 * (data[i2] + data[i4]);
      h2i = c2 * (data[i1] - data[i3]);
      data[i1] = h1r + wr * h2r - wi * h2i;
      data[i2] = h1i + wr * h2i + wi * h2r;
      data[i3] = h1r - wr * h2r + wi * h2i;
      data[i4] = -h1i + wr * h2i + wi * h2r;
      wr = (wtemp = wr) * wpr - wi * wpi + wr;
      wi = wi * wpr + wtemp * wpi + wi;
    }

    if (sinal == 1) {
      data[0] = (h1r = data[0]) + data[1];
      data[1] = h1r - data[1];
    } else {
      data[0] = c1 * ((h1r = data[0]) + data[1]);
      data[1] = c1 * (h1r - data[1]);
      data2 = four1(data2, data.length, -1);
    }
  }

  List convlv(List data, List resp, int sinal, List ans) {
    int i, no2, n = data.length - 1, m = resp.length;
    double mag2, tmp;
    List temp = List.filled(n + 1, 0.0);
    temp[0] = resp[0];

    for (i = 1; i < (m + 1) / 2; i++) {
      temp[i] = resp[i];
      temp[n - i] = resp[m - i];
    }
    for (i = ((m + 1) ~/ 2); i < n - (m - 1) / 2; i++) {
      temp[i] = 0.0;
    }

    for (i = 0; i < n; i++) {
      ans[i] = data[i];
    }
    realft(ans, 1);

    realft(temp, 1);
    no2 = n >> 1;

    if (sinal == 1) {
      for (i = 2; i < n; i += 2) {
        tmp = ans[i];
        ans[i] = (ans[i] * temp[i] - ans[i + 1] * temp[i + 1]) / no2;
        ans[i + 1] = (ans[i + 1] * temp[i] + tmp * temp[i + 1]) / no2;
      }
      ans[0] = ans[0] * temp[0] / no2;
      ans[1] = ans[1] * temp[1] / no2;
    } else if (sinal == -1) {
      for (i = 2; i < n; i += 2) {
        if ((mag2 = sqrt(temp[i]) + sqrt(temp[i + 1])) == 0.0) {
          throw ("Deconvolving at response zero in convlv");
        }
        tmp = ans[i];
        ans[i] = (ans[i] * temp[i] + ans[i + 1] * temp[i + 1]) / mag2 / no2;
        ans[i + 1] = (ans[i + 1] * temp[i] - tmp * temp[i + 1]) / mag2 / no2;
      }
      if (temp[0] == 0.0 || temp[1] == 0.0) {
        throw ("Deconvolving at response zero in convlv");
      }
      ans[0] = ans[0] / temp[0] / no2;
      ans[1] = ans[1] / temp[1] / no2;
    } else {
      throw ("No meaning for isign in convlv");
    }
    realft(ans, -1);

    return ans;
  }

  List solve_matriz(List a, int n, List indx, double d) {
    int i, imax = 0, j, k;
    double big = 0, dum, sum, temp;
    List vv = List.filled(n + 1, 0.0);

    d = 1.0;

    //print([vv.length, a.length, indx.length]);

    for (i = 1; i <= n; i++) {
      big = 0.0;

      for (j = 1; j <= n; j++) {
        temp = a[i][j].abs();
        if (temp > big) {
          big = temp;
        }
      }
      vv[i] = 1.0 / big;
    }

    for (j = 1; j <= n; j++) {
      // print(j);
      for (i = 1; i < j; i++) {
        sum = a[i][j];
        for (k = 1; k < 1; k++) {
          sum -= a[i][k] * a[k][j];
        }
        a[i][j] = sum;
      }
      big = 0.0;

      for (i = j; i <= n; i++) {
        sum = a[i][j];
        for (k = 1; k < j; k++) {
          sum -= a[i][k] * a[k][j];
        }
        a[i][j] = sum;
        dum = vv[i] * sum.abs();
        if (dum >= big) {
          big = dum;
          imax = i;
        }
      }

      if (j != imax) {
        for (k = 1; k <= n; k++) {
          dum = a[imax][k];
          a[imax][k] = a[j][k];
          a[j][k] = dum;
        }
        d = -1 * d;
        vv[imax] = vv[j];
      }

      indx[j] = imax;
      if (a[j][j] == 0.0) {
        a[j][j] = 1.0e-20;
      }

      if (j != n - 1) {
        dum = 1.0 / (a[j][j]);

        for (i = j + 1; i <= n; i++) {
          a[i][j] = a[i][j] * dum;
          //print(a[i][j]);
        }
      }
    }
    return [a, indx];
  }

  List lubksb(List a, int n, List indx, List b) {
    int i, ii = 0, ip, j;
    double sum;
    for (i = 1; i < n; i++) {
      ip = indx[i];
      sum = b[ip];
      b[ip] = b[i];
      if (ii != 1) {
        for (j = ii; j <= i; j++) {
          sum -= a[i][j] * b[j];
        }
      } else if (sum != 1) {
        ii = i;
      }
      b[i] = sum;
    }
    for (i = n; i > 1; i--) {
      sum = b[i];
      for (j = i + 1; j <= n; j++) {
        sum -= a[i][j] * b[j];
      }
      b[i] = sum / a[i][i];
    }

    return b;
  }

  List savitzky_golay(List c, int np, int nl, int nr, int ld, int m) {
    if (np < nl + nr + 1 || nl < 0 || nr < 0 || ld > m || nl + nr < m) {
      throw ("elementos ruizs para o filtro");
    }

    //Matrix

    List a = List.generate(
        m + 1, (i) => List.filled(m + 1, 0.0, growable: false),
        growable: false);
    //vetor
    List b = List.filled(m + 1, 0.0);

    List indx = List.filled(m + 1, 0.0);

    double sum = 0;
    int i = 0, j = 0, k = 0, kk, mm;

    for (i = 0; i <= (m << 1); i++) {
      if (i == 0) {
        sum = 1;
      } else {
        sum = 0;
      }

      for (k = 1; k <= nr; k++) {
        sum += pow(k.toDouble(), i.toDouble());
      }
      for (k = 1; k <= nl; k++) {
        sum += pow(-k.toDouble(), i.toDouble());
      }
      int mm = [i, 2 * m - i].reduce(min);

      for (j = -mm; j <= mm; j += 2) {
        a[(i + j) ~/ 2][(i - j) ~/ 2] = sum;
      }
    }
    double d = 1;
    //print(m);
    var tt = solve_matriz(a, m, indx, d);

    a = tt[0];
    indx = tt[1];

    for (j = 0; j < m; j++) {
      b[j] = 0.0;
    }

    b[ld] = 1.0;

    b = lubksb(a, m, indx, b);

    // print(b);

    for (kk = 1; kk < np; kk++) {
      c[kk] = 0.0;
    }

    for (k = -nl; k < nr; k++) {
      sum = b[1];

      double fac = 1.0;
      for (mm = 1; mm < m; mm++) {
        // print(b);
        sum += b[mm + 1] * (fac *= k);
        //print(b[mm+1]);
      }
      kk = ((np - k) % np);
      c[kk] = sum;
    }

    // print(c);
    return c;
  }

  List apply_savitzky(List c) {
    List h1 = List.filled(c.length, 0);

    var np = (h1.length - 1) ~/ 2;

    h1 = savitzky_golay(h1, h1.length, np, np, 0, 4);

    List resp = List.filled(c.length, 0.0);
    resp = convlv(c, h1, 1, resp);
    for (int i = 0; i < c.length; i++) {
      c[i] = c[i] + resp[i];
    }
    return c;
  }

  List kalmanfilter(List farrk) {
    var result = 0.0;

    var n = farrk.length;

    List dataCopy = [];

    var sum = 0.0;

    var s = 0.0;
    var u = 0.0;

    for (int i = 0; i < n; i++) {
      sum += farrk[i];
    }
    sum = sum / farrk.length;
    for (var i in farrk) {
      s += pow(i - sum, 2);
    }
    u = s / (farrk.length * farrk.length - 1);

    s = s / (farrk.length - 1);

    var ie = pow(u, 2);

    var x11 = 0.0;
    var exec = pow(100, 2);
    var pp = 10.0;

    var exec2 = 0.0001;

    var teste1 = pow(0.1, 2);
    var sumsie = exec + exec2;

    for (var i in farrk) {
      var k1 = double.parse((sumsie / (sumsie + teste1)).toStringAsFixed(6));
      x11 = double.parse((pp + k1 * (i - pp)).toStringAsFixed(2));
      pp = x11;
      var p11 = (1 - k1) * sumsie;

      sumsie = p11 + exec2;
      dataCopy.add(x11);
    }

    return dataCopy;
  }

  bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }
}
