#include "getaccinfo.h"

getAccInfo::getAccInfo(QObject *parent) : QObject(parent)
{
    setNbDonnees(0);    
    gfltMinValue[0][0] = 0;
    gfltMaxValue[0][0] = 0;
    gfltMinValue[0][1] = 0;
    gfltMaxValue[0][1] = 0;

    gIntNbTotalMVT[0] = 0;
    gIntNbTotalDechets[0] = 0;
    gTblIntNbMVT[0][0] = 0;
    gIntDureeEnSecondeTransmission = 0; // Durée en seconde de chaque Transmission d'enregistrement
    gintNbTotalTransmission = 0; //En nombre de Transmission
    gIntNbSuccesTransmission = 0;

    gFltRythmeInstantMVT = 0;
    gFltRythmeMoyenMVT = 0;
    setDureeTransmission(DUREETransmissionDEFAUT);

    //mydb.setDatabaseName("/home/eldecog/untitled/db/ptms.db");
    mydb.setHostName("localhost");
    mydb.setDatabaseName("vaucheptms");
    mydb.setUserName("ptms");
    mydb.setPassword("Iluv2w0rk");
    bool ok = mydb.open();
    //mydb.removeDatabase("ptms.db");
}

void getAccInfo::autoreadFile(QString qstrMontreGauche, QString qstrMontreDroit)
{
    int lintNb=0;
    bool lblSuccess = false;
    QString sPath = "/home/eldecog/nodejs/upload/";
    QString filename = "";
    QString destFile = "sauvegarde";
    gshtNbMontres = 0;

    for (int lintMontre=0;lintMontre<WATCHPERAGENT;lintMontre++)
    {
        if (lintMontre==0)
            lintNb = qstrMontreDroit.length();
        else
            lintNb = qstrMontreGauche.length();
        if (lintNb>2)
        {
            gshtNbMontres++;
            if (lintMontre==0)
                filename = "*" +qstrMontreDroit+".dat";
            else
                filename = "*" +qstrMontreGauche+".dat";
            filemodel = new QDir(sPath,filename);
            filemodel->setFilter(QDir::Files);

            //qDebug() << filemodel->entryList().count();
            if (filemodel->entryList().count()>=MAXACCFILES)
                setNbAxes(MAXACCFILES);
            else
                setNbAxes(filemodel->entryList().count());

            setNbDonnees(0);

            for (int lintNbFile=0;lintNbFile<getNbAxes();lintNbFile++)
            {
                filename = sPath;
                filename.append(filemodel->entryList().at(lintNbFile));
                //qDebug() << filename;

                QFile mFile(filename);

                if (!mFile.open(QFile::ReadOnly))
                {
                    qDebug() << "Couldn't open the file";
                    return;
                }
                QByteArray blob =mFile.readAll();
                if (MAXFILESIZE>=blob.count()/4)
                    setNbDonnees(blob.count()/4);
                else
                    setNbDonnees(MAXFILESIZE);

                lintNb = getNbDonnees();

                gfltAcc[lintNbFile][0][lintMontre] = *reinterpret_cast<float*>(blob.data());
                gfltMinValue[lintNbFile][lintMontre] = gfltAcc[lintNbFile][0][lintMontre];
                gfltMaxValue[lintNbFile][lintMontre] = gfltAcc[lintNbFile][0][lintMontre];
                for (int i=1;i<lintNb;i++)
                {
                    gfltAcc[lintNbFile][i][lintMontre] = *reinterpret_cast<float*>(blob.data()+4*i);
                    if (gfltAcc[lintNbFile][i][lintMontre]>gfltMaxValue[lintNbFile][lintMontre])
                        gfltMaxValue[lintNbFile][lintMontre] = gfltAcc[lintNbFile][i][lintMontre];
                    if (gfltAcc[lintNbFile][i][lintMontre]<gfltMinValue[lintNbFile][lintMontre])
                        gfltMinValue[lintNbFile][lintMontre] = gfltAcc[lintNbFile][i][lintMontre];
                }

                //qDebug() << "The file is opened and read !";

                mFile.close();

                //filemodel->remove(filename);
                // Deplace le fichier dans un repertoire de sauvegarde :
                destFile = sPath + "PTMS_Saved/" + filemodel->entryList().at(lintNbFile);
                filemodel->rename(filename,destFile);

                //qDebug() << "The number of elements read is : " << getNbDonnees();
                //qDebug() << "The '1st' value read is : " << getValueX(1);
                lblSuccess = true;
            }
            delete filemodel;
        }
    }
    if (gintNbTotalTransmission<NBMAXTransmissionS)
        gintNbTotalTransmission++; // peu importe qu'il ait réussi ou non à lire le fichier, il y a eu une nouvelle tentative de Transmission
    else
        gintNbTotalTransmission = 0;

    if (lblSuccess)
        gIntNbSuccesTransmission++;
}

float getAccInfo::getValueX(int lintIndex, bool lblMontre)
{
    //qDebug() << "The requested value is : " << gfltAccX[lintIndex] << " ["<<lintIndex<<"]";
    return gfltAcc[0][lintIndex][lblMontre];
}

float getAccInfo::getValueY(int lintIndex, bool lblMontre)
{
    return gfltAcc[1][lintIndex][lblMontre];
}

float getAccInfo::getValueZ(int lintIndex, bool lblMontre)
{
    return gfltAcc[2][lintIndex][lblMontre];
}

float getAccInfo::getValue(int lintIndex, int lintAccelerometre, bool lblMontre)
{
    return gfltAcc[lintAccelerometre][lintIndex][lblMontre];
}

float getAccInfo::getCombinaison(int lintIndex, bool lblMontre)
{
     return gfltCombinaisonAcc[lblMontre][lintIndex];
}

int getAccInfo::getNbDonnees()
{
    return gintNombreDonnees;
}

int getAccInfo::getNbAxes(bool lblMontre)
{
    return gintNombreAxes[lblMontre];
}

int getAccInfo::getNbMouvements(bool lblMontre)
{
    int lintNbMvt = 0, lintNbDechet = 0;
    gIntNbMVT[lblMontre] = lintNbMvt;
    gIntNbDechets[lblMontre] = lintNbDechet; // au cas ou on ne trouve rien il dira que c'est zero

    float lfltCoeff[MAXACCFILES], lfltMaxCoef=0;
    float lfltTotal = 0;
    for (int lintJ=0;lintJ<getNbAxes();lintJ++)
    {
        lfltCoeff[lintJ] = qAbs(getAmplitude(lintJ) * qAbs(getAmplitude(lintJ)*getMean(lintJ))*sum(&gfltAcc[lintJ][0][lblMontre],getNbDonnees(),0,getNbDonnees()));
        lfltTotal += lfltCoeff[lintJ];
        if (lfltCoeff[lintJ]>lfltMaxCoef)
            lfltMaxCoef = lfltCoeff[lintJ];
        //qDebug() << "coef("<<lintJ<<") : "<< lfltCoeff[lintJ];
    }

    //qDebug() << "Total = "<< lfltMaxCoef;
    //qDebug() << "Max = "<< lfltTotal;
    for (int lintJ=0;lintJ<getNbAxes();lintJ++)
        lfltCoeff[lintJ] /= lfltMaxCoef;
    if (lfltTotal<(1000000))
        return 0;

    for (int lintI=0;lintI<getNbDonnees();lintI++)
    {
        gfltCombinaisonAcc[lblMontre][lintI] = 0;
        for (int lintJ=0;lintJ<getNbAxes();lintJ++)
            gfltCombinaisonAcc[lblMontre][lintI] += lfltCoeff[lintJ]*getValue(lintI,lintJ,lblMontre);

    }
    gfltWindowAverage[TAILLEOFF-1]=0;
    for (int i=TAILLEOFF;i<getNbDonnees();i++)
    {
        gbolChangeDirection[i] = 0;
        gfltWindowAverage[i] = mean(&gfltCombinaisonAcc[lblMontre][0],getNbDonnees(),(i-TAILLEWIN+1),i);
        //qDebug() << "ValeurDetection : " << (gfltWindowAverage[i])<<"<- 4: "<< gfltCombinaisonAcc[i-3]<<"; 3: "<< gfltCombinaisonAcc[i-2]<<"; 2: "<< gfltCombinaisonAcc[i-1]<<"; 1: "<< gfltCombinaisonAcc[i];
        gfltWindowAverage[i] = gfltWindowAverage[i] - mean(&gfltCombinaisonAcc[lblMontre][0],getNbDonnees(),reinterpret_cast<int>(i-TAILLEOFF+1),reinterpret_cast<int>(i));

        if ((gfltWindowAverage[i-1]/gfltWindowAverage[i])<SEUILDETECTIONDechets)
            if (qAbs(gfltWindowAverage[i]-gfltWindowAverage[i-TAILLEWIN+1])>SEUILACCEG)
                lintNbDechet++;

        if ((gfltWindowAverage[i-1]/gfltWindowAverage[i])<SEUILDETECTION)
            if (qAbs(gfltWindowAverage[i]-gfltWindowAverage[i-TAILLEWIN+1])>SEUILACCEG)
            {
                gbolChangeDirection[i] = 1;
                lintNbMvt++;
            }
    }

    lintNbMvt /=2;
    lintNbDechet/=2;
    gIntNbMVT[lblMontre] = lintNbMvt;
    gIntNbDechets[lblMontre] = lintNbDechet;
    gIntNbTotalMVT[lblMontre] += gIntNbMVT[lblMontre]; // Ajoute au nombre total de mouvements
    gIntNbTotalDechets[lblMontre] += lintNbDechet;
    gTblIntNbMVT[gintNbTotalTransmission][lblMontre] = gIntNbMVT[lblMontre];

    //qDebug() << "Nombre de mouvements : " << gIntNbMVT[lblMontre] <<" ("<<lblMontre << ")";

    CaracteriseMVT();

    return gIntNbMVT[lblMontre];
}

float getAccInfo::getNiveauRisque(int lintIndividu)
{
    //niveau de risaue
    //duree de travail :
    //la duree chaude 2h
    int lintDuree = getTempsTravail();// TODO cette fonction doit dependre de l individu concern2
    float lfltRisqueTampon = 0;
    lfltRisqueTampon = (lintDuree/60)/(120); //TODO au bout de combien de temps ca commence a etre chaud?

    //age
    int lintAge  = getIndividuAge(lintIndividu);
    lfltRisqueTampon += (lintAge-16)/(60-16); //TODO Age maxi et age mini correspondant au risque

    // nombre de mouvement total (AT)
    int lintNbTotalMVT = getIntNbTotalMVT();
    lintNbTotalMVT += getIntNbTotalMVT(1);// TODO cette fonction doit dependre de l individu concern2

    lfltRisqueTampon +=lintNbTotalMVT/1000; // au dela de combien d'actions technique c est chaud ?


    //le rythme moyen
    float lfltRythme = getFltRythmeMoyenMVT();// TODO cette fonction doit dependre de l individu concern2
    lfltRisqueTampon += lfltRythme/60;

    lfltRythme = getFltRythmeMoyenMVT(1);// TODO cette fonction doit dependre de l individu concern2
    lfltRisqueTampon += lfltRythme/60;


    // le rythme cardiaque
    // TODO

    // le genre
    // TODO

    // le niveau des vibrations
    // TODO

    // le nombre d'amplitudes rouges et jaune
    // TODO

    // le nombre de charges lourdes
    // TODO

    lfltRisqueTampon =  100*lfltRisqueTampon/5 ;
    return lfltRisqueTampon;
}

float getAccInfo::getMin(int lintAccelerometre, bool lblMontre)
{
    return gfltMinValue[lintAccelerometre][lblMontre];
}

float getAccInfo::getMax(int lintAccelerometre, bool lblMontre)
{
    return gfltMaxValue[lintAccelerometre][lblMontre];
}

float getAccInfo::getGeneralMax(bool lblMontre)
{
    float lfltMax =0;
    for (int lintI=0, lintNbAxes = getNbAxes();lintI<lintNbAxes;lintI++)
    {
        if (lfltMax<getMax(lintI,lblMontre))
            lfltMax = getMax(lintI,lblMontre);
    }
    return lfltMax;
}

float getAccInfo::getGeneralMin(bool lblMontre)
{
    float lfltMin =0;
    for (int lintI=0, lintNbAxes = getNbAxes();lintI<lintNbAxes;lintI++)
    {
        if (lfltMin>getMin(lintI,lblMontre))
            lfltMin = getMin(lintI,lblMontre);
    }
    return lfltMin;
}

void getAccInfo::setNbDonnees(int lintValue)
{
    gintNombreDonnees =lintValue;
}

void getAccInfo::setNbAxes(int lintAxes, bool lblMontre)
{
    gintNombreAxes[lblMontre] = lintAxes;
}

float getAccInfo::getAmplitude(int lintAccelerometre=0)
{
    return getMax(lintAccelerometre)-getMin(lintAccelerometre);
}

float getAccInfo::getMean(int lintAccelerometre)
{
    float lfltMean = getValue(0,lintAccelerometre);
    lfltMean = lfltMean/getNbDonnees();
    for (int lintI=1;lintI<getNbDonnees();lintI++)
        lfltMean += getValue(lintI,lintAccelerometre)/getNbDonnees();
    return lfltMean;
}

float getAccInfo::mean(float* lfltTableau, int lintTailleTableau, int lintDebut, int lintFin)
{
    if ((lintFin>lintDebut)&(lintDebut>0))
    {
        if (lintTailleTableau>0)
        {
            int lintNbDonnees = lintFin-lintDebut;
            float lfltMean = lfltTableau[lintDebut]/lintNbDonnees;
            for (int i=lintDebut+1;i<lintFin;i++)
                lfltMean += lfltTableau[i]/lintNbDonnees;

            return lfltMean;
        }
        else
            return -9999;
    }
    else
        return -9999;
}

float getAccInfo::sum(float *lfltTableau, int lintTailleTableau, int lintDebut, int lintFin)
{
    if ((lintFin>lintDebut)&(lintDebut>0))
    {
        if (lintTailleTableau>0)
        {
            float lfltSum = lfltTableau[lintDebut];
            for (int i=lintDebut+1;i<lintFin;i++)
                lfltSum += lfltTableau[i];

            return lfltSum;
        }
        else
            return -9999;
    }
    else
        return -9999;
}

float getAccInfo::min(float *lfltTableau, int lintTailleTableau, int lintDebut, int lintFin)
{
    float lfltSortie = -9999;
    if ((lintFin>lintDebut) & ((lintFin-lintDebut)<=lintTailleTableau))
    {
        if (lintTailleTableau>0)
        {
            lfltSortie = lfltTableau[lintDebut];
            for (int i=lintDebut+1;i<lintFin;i++)
                if (lfltSortie>lfltTableau[i])
                    lfltSortie = lfltTableau[i];
        }
        else
            return -9999;
    }
    else
        return -9999;
    return lfltSortie;
}

float getAccInfo::max(float *lfltTableau, int lintTailleTableau, int lintDebut, int lintFin)
{
    float lfltSortie = -9999;
    if ((lintFin>lintDebut) & ((lintFin-lintDebut)<=lintTailleTableau))
    {
        if (lintTailleTableau>0)
        {
            lfltSortie = lfltTableau[lintDebut];
            for (int i=lintDebut+1;i<lintFin;i++)
                if (lfltSortie<lfltTableau[i])
                    lfltSortie = lfltTableau[i];
        }
        else
            return -9999;
    }
    else
        return -9999;
    return lfltSortie;
}

int getAccInfo::maxPos(float *lfltTableau, int lintTailleTableau, int lintDebut, int lintFin)
{
    float lfltSortie = -9999;
    int lintSortie = -9999;
    if ((lintFin>lintDebut) & ((lintFin-lintDebut)<=lintTailleTableau))
    {
        if (lintTailleTableau>0)
        {
            lfltSortie = lfltTableau[lintDebut];
            lintSortie = lintDebut;
            for (int i=lintDebut+1;i<lintFin;i++)
                if (lfltSortie<lfltTableau[i])
                {
                    lfltSortie = lfltTableau[i];
                    lintSortie = i;
                }
        }
        else
            return -9999;
    }
    else
        return -9999;
    return lintSortie;
}

int getAccInfo::minPos(float *lfltTableau, int lintTailleTableau, int lintDebut, int lintFin)
{
    float lfltSortie = -9999;
    int lintSortie = -9999;
    if ((lintFin>lintDebut) & ((lintFin-lintDebut)<=lintTailleTableau))
    {
        if (lintTailleTableau>0)
        {
            lfltSortie = lfltTableau[lintDebut];
            lintSortie = lintDebut;
            for (int i=lintDebut+1;i<lintFin;i++)
                if (lfltSortie<lfltTableau[i])
                {
                    lfltSortie = lfltTableau[i];
                    lintSortie = i;
                }
        }
        else
            return -9999;
    }
    else
        return -9999;
    return lintSortie;
}

void getAccInfo::setDureeTransmission(int lintNbSecondes)
{
    gIntDureeEnSecondeTransmission = lintNbSecondes;
}

float getAccInfo::getFltRythmeInstantMVT(bool lblMontre)
{
    return gIntNbMVT[lblMontre]*60/getDureeTransmission();
}

float getAccInfo::getFltRythmeMoyenMVT(bool lblMontre)
{
    if (getDureeTotaleEnregistrementEnMinutes())
        return gIntNbTotalMVT[lblMontre]*60/(gintNbTotalTransmission*getDureeTransmission());
    else
        return getFltRythmeInstantMVT(lblMontre);
}

int getAccInfo::getDureeTotaleEnregistrement()
{
    return gintNbTotalTransmission*getDureeTransmission();
}

int getAccInfo::getDureeTotaleEnregistrementEnMinutes()
{
    return gintNbTotalTransmission*getDureeTransmission()/60;
}

int getAccInfo::getIntNbTotalTransmission()
{
    return gintNbTotalTransmission;
}

int getAccInfo::getIntNbSuccesTransmission()
{
    return gIntNbSuccesTransmission;
}

int getAccInfo::getTempsTravail()
{
    return gIntNbSuccesTransmission*getDureeTransmission();
}

int getAccInfo::getIntNbTotalMVT(bool lblMontre)
{
    return gIntNbTotalMVT[lblMontre];
}

int getAccInfo::getTblIntNbMVT(int lintIndex, bool lblMontre)
{
    if (lintIndex<NBMAXTransmissionS)
        return gTblIntNbMVT[lintIndex][lblMontre];
    else
        return -9999;
}

bool getAccInfo::startTransmission(int lintIndividu)
{

    return true;
}

QString getAccInfo::getDBValue(QString qstrTable, QString qstrRow, int lintIndex)
{
    if (!mydb.open())
    {
        return "-9000";
    }
    else
    {
        //qDebug() << "Database is opened!";
        QSqlQuery sqry(mydb);
        if (sqry.exec("SELECT "+qstrRow+" FROM "+ qstrTable + " WHERE Id="+QString::number(lintIndex)))
        {
            int lintCount=0;
            sqry.first();
            {
                lintCount++;
                //qDebug() << sqry.value(0).toString();
                return sqry.value(0).toString();
            }
        }
        else
            qDebug() << "mmh something got wrong while retrieving the data";
        return "-9999";
    }
}

QString getAccInfo::getMontreSN(int lintIndividu, bool lblMontreGauche)
{
    if (!mydb.open())
    {
        return "-9000";
    }
    else
    {
        //qDebug() << "Database is opened!";
        QSqlQuery sqry(mydb);
        QString lstQuery = "SELECT montres.codeID from identites, Montres where identites.Id="+QString::number(lintIndividu);
        if (lblMontreGauche)
            lstQuery += " and identites.Montre_Gauche=Montres.Id";
        else
            lstQuery += " and identites.Montre_Droit=Montres.Id";
        if (sqry.exec(lstQuery))
        {
            int lintCount=0;
            if (sqry.first())
            {
                lintCount++;
                return sqry.value(0).toString();
            }
        }
        else
            qDebug() << lstQuery;
        return "-9999";
    }
}

int getAccInfo::getIndividuAge(int lintIndividu)
{
    QString lstrDateDeNaissance = getDBValue("identites","Date_de_naissance",lintIndividu);
    //qDebug() <<  lstrDateDeNaissance.split("/")[0];
    QString lstrYear = lstrDateDeNaissance.split("/")[2], lstrMonth=lstrDateDeNaissance.split("/")[1], lstrDay=lstrDateDeNaissance.split("/")[0];
    QDate ldateNaissance(lstrYear.toInt(),lstrMonth.toInt(),lstrDay.toInt());
    //qDebug() << ldateNaissance.daysTo(QDate::currentDate());
    return ldateNaissance.daysTo(QDate::currentDate())/365.25;
}

int getAccInfo::getNombreAgents()
{
    if (!mydb.open())
        return -9000;
    else
    {
        QSqlQuery sqry(mydb);
        QString lstQuery = "SELECT  count(Id) from identites";

        if (sqry.exec(lstQuery))
        {
            if (sqry.first())
            {
                return sqry.value(0).toInt();//.toString();
            }
        }
        else
            qDebug() << lstQuery;
        return -9999;
    }
}

QString getAccInfo::getAgentNomLst(int lintIndex)
{
    if (!mydb.open())
        return "-9000";
    else
    {
        QSqlQuery sqry(mydb);
        QString lstQuery = "SELECT Nom from identites limit 1 offset "+QString::number(lintIndex);

        if (sqry.exec(lstQuery))
        {
            if (sqry.first())
            {
                return sqry.value(0).toString();
            }
        }
        else
            qDebug() << lstQuery;
        return "-9999";
    }
}

int getAccInfo::getAgentId(int lintIndex)
{
    if (!mydb.open())
        return -9000;
    else
    {
        QSqlQuery sqry(mydb);
        QString lstQuery = "SELECT Id,Nom from identites limit 1 offset "+QString::number(lintIndex);

        if (sqry.exec(lstQuery))
        {
            if (sqry.first())
            {
                return sqry.value(0).toInt();
            }
        }
        else
            qDebug() << lstQuery;
        return -9999;
    }
}

int getAccInfo::getNbDechets(bool lblMontre)
{
    return gIntNbDechets[lblMontre];
}

int getAccInfo::getNbDechetsTotal(bool lblMontre)
{
    return gIntNbTotalDechets[lblMontre];
}

int getAccInfo::getDureeTransmission()
{
    return gIntDureeEnSecondeTransmission;
}

void getAccInfo::CaracteriseMVT()
{
    for (int i=TAILLEOFF;i<getNbDonnees();i++)
    {
        /*
         * passe en revue le tableau de tick
         * s'il voit un tick alors il recherche dans le tableau des valeurs de combinaison des accélération
         * la valeur min ou la valeur max, ensuite fait ça une 2eme fois au prochain tick
         */
        int lintDuree = 0;
        float lfltAmplitude = 0;
        int j=gIntNbTotalMVT[0] - gIntNbMVT[0];

        if (gbolChangeDirection[i])
            if ((i>TAILLESEARCH)&(j<NBMAXMVT))
            {
                if (gfltCombinaisonAcc[0][i-1]>gfltCombinaisonAcc[0][i+1])
                {
                    lintDuree = maxPos(gfltCombinaisonAcc[0],MAXFILESIZE, i-TAILLESEARCH, i);
                    lintDuree += minPos(gfltCombinaisonAcc[0],MAXFILESIZE,i,i+TAILLESEARCH);
                    gintDuree[j] = lintDuree;
                    lfltAmplitude = max(gfltCombinaisonAcc[0],MAXFILESIZE, i-TAILLESEARCH, i);
                    lfltAmplitude += min(gfltCombinaisonAcc[0],MAXFILESIZE,i,i+TAILLESEARCH);
                    gfltAmplitude[j++] = lfltAmplitude;
                }
                else
                {
                    lintDuree = maxPos(gfltCombinaisonAcc[0],MAXFILESIZE,i,i+TAILLESEARCH);
                    lintDuree += minPos(gfltCombinaisonAcc[0],MAXFILESIZE, i-TAILLESEARCH, i);
                    gintDuree[j] = lintDuree;
                    lfltAmplitude = max(gfltCombinaisonAcc[0],MAXFILESIZE,i,i+TAILLESEARCH);
                    lfltAmplitude += min(gfltCombinaisonAcc[0],MAXFILESIZE, i-TAILLESEARCH, i);
                    gfltAmplitude[j++] = lfltAmplitude;
                }
            }
    }

}
