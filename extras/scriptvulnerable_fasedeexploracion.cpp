#include <iostream>
using namespace std;

int main(){
    string unidadesS, precioS;
    int unidades, precio;
    cout << "Dime el numero de unidades: ";
    cin >> unidadesS;

    unidades = stoi(unidadesS);

    if(unidades == 1){
        precio = unidades * 100;
    }else if (unidades == 2){
        precio = unidades * 95;
    }else if (unidades == 3){
        precio = unidades * 90;
    }else{
        precio = unidades * 85;
    }


    cout << "Eso son " << precio << "euros";
}
