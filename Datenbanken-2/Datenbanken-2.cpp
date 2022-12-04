#pragma warning(disable : 4996)
#include <iostream>
#include "DBSim.h"

using namespace std;

string readLine()
{
    char str[200];
    cin.getline(str, 50);
    string s(str);
    return s;
}

void clearBuffer()
{
    cin.clear();
    cin.ignore(200, '\n');
}

/** \brief Laedt die Datenbank von einer Datei, dessen Name vom Nutzer bestimmt wird
 *
 * \param obj DBSim*, Datenbank
 * \return void
 *
 */
void laden(DBSim* obj)
{
    //cout << "Dateiname:" << endl;
    //string fileName = readLine();
    //    clearBuffer();
    string fileName = "test.txt";
    obj->loadFile(fileName);
}

/** \brief Speichert die Datenbank in eine Datei, dessen Name vom Nutzer bestimmt wird
 *
 * \param obj DBSim*, Datenbank
 * \return void
 *
 */
void speichern(DBSim* obj)
{
    obj->saveFile("backup.txt");
}

/** \brief Sucht in der Datenbank nach einem vom Nutzer eingegebenen Autor
 *
 * \param obj DBSim*, Datenbank
 * \return void
 *
 */
void suchen(DBSim* obj)
{
    cout << "Autor:" << endl;
    string suchBegriff = readLine();
    clearBuffer();
    obj->searchAuthor(suchBegriff);
}

int main()
{
    try
    {
        char input;
        DBSim sim;
        do
        {
            system("CLS");
            cout
                << "Datenbank 2" << endl
                << "1. Datei laden" << endl
                << "2. Datei speichern" << endl
                << "3. Indexarray aufbauen" << endl
                << "4. Indexarray sortieren" << endl
                << "5. DB ausgeben" << endl
                << "6. Autor suchen" << endl
                << "9. Beenden" << endl
                << ((sim.noTable()) ? "Keine Tabelle\n" : "")
                << ((sim.noIndex()) ? "Kein Index\n" : "");

            cin >> input;
            while (cin.fail())
            {
                std::cin.clear();
                std::cin.ignore(256, '\n');
                cin >> input;
            }
            clearBuffer();
            try
            {

                switch (input)
                {
                case '1':
                    laden(&sim);
                    break;

                case '2':
                    speichern(&sim);
                    system("pause");
                    break;
                case '3':
                    sim.createIndex();
                    system("pause");
                    break;
                case '4':
                    sim.sortIndexArray();
                    system("pause");
                    break;
                case '5':
                    sim.print();
                    system("pause");
                    break;
                case '6':
                    suchen(&sim);
                    system("pause");
                    break;
                case '9':
                    cout << "Programm wird beendet";
                    break;
                default:
                    cout << "Menüpunkt nicht vorhanden" << endl;
                    system("pause");
                }
            }
            catch (const char* err)
            {
                cout << err << endl;
                system("pause");
            }
        } while (input != '9');
    }
    catch (const char* err)
    {
        cout << err << endl;
    }
    return 0;
}
