// Valentina Bohorquez – 
// Visualizacion creativa de base de datos en formato circular
// Se utiliza el dataset de Kaggle sobre precios de carros usados
// Esta visualizacion representa la cantidad de carros por tipo de combustible y ano, en forma radial, para uqe se logre observar mejor


// Declaro la tabla de datos (table)
// Despues, creo 3 contadores (IntDict) para guardar cuantos carros hay por ano, seugn su tipo de combustible y yearStrings guardara los anos uincos
// Se crean las variables para mostrar un recuadro (tooltip) con datos cuando se pase el mouse sobre una linea por en los extremos
Table table;
IntDict petrolByYear, dieselByYear, otherByYear;
String[] yearStrings;

// Variables tooltip
String infoYear = "";
String infoTipo = "";
int infoCantidad = 0;
boolean mostrarInfo = false;


// Defino el tamano de la ventana
// Cargo el archivo .csv de Kaggle

void setup() {
  size(900, 900);
  table = loadTable("used_car_price_dataset_extended.csv", "header");

// Inicializo 3 diccionarios para contar cuantos carros hay de cada tipo en este caos (Petrol, Diesel, Other) por ano

  petrolByYear = new IntDict();
  dieselByYear = new IntDict();
  otherByYear = new IntDict();
  
// Recorre todas las filas del archivo CSV
// Aca, extrae el ano (make_year) y el tipo de combustible (fuel_type) de cada fila

  for (TableRow row : table.rows()) {
    String year = row.getString("make_year");
    String fuel = row.getString("fuel_type");

    if (fuel.equals("Petrol")) {
      petrolByYear.increment(year);
    } else if (fuel.equals("Diesel")) {
      dieselByYear.increment(year);
    } else {
      otherByYear.increment(year);
    }
  }

// Guarda todos los anos unicos, los importantes del diccionario petrolByYear en un arreglo
  yearStrings = petrolByYear.keyArray();
}

// coloco la pantalla con un color lila claro
// mueve el origen (0,0) al centro de la pantalla para que todo se dibuje desde ahi hacia la parte de afuera

void draw() {
  background(248, 242, 255);
  translate(width / 2, height / 2);
  
  // Calcula caunto debe girar cada ''petalo'' para que se repartan en circulo
  // Reinicia la variable del tooltip
  float angleStep = TWO_PI / yearStrings.length;

  mostrarInfo = false;

// Recorre todos los anos
// Para cada uno, llama a una funcion que dibuja 3 lineas separadas: una para cada tipo de combustibel
  for (int i = 0; i < yearStrings.length; i++) {
    float angle = i * angleStep;
    String year = yearStrings[i];

    int petrol = petrolByYear.get(year);
    int diesel = dieselByYear.get(year);
    int other = otherByYear.get(year);

    // Capas separadas
    dibujarLineaInteractiva(angle, 120, petrol, 255, 70, 100, "Petrol", year);  // Interno
    dibujarLineaInteractiva(angle, 220, diesel, 70, 120, 255, "Diesel", year);  // Medio
    dibujarLineaInteractiva(angle, 320, other, 60, 200, 140, "Other", year);    // Externo
  }

  // Texto arriba
  resetMatrix();
  fill(30);
  textAlign(CENTER);
  textSize(20);
  text("Distribucion circular de combustible por tipo", width / 2, 40);

  // Mostrar tooltip si corresponde
  if (mostrarInfo) {
    fill(0, 180);
    rect(mouseX + 10, mouseY - 30, 160, 50, 8);
    fill(255);
    textSize(12);
    textAlign(LEFT);
    text("Año: " + infoYear, mouseX + 15, mouseY - 15);
    text("Combustible: " + infoTipo, mouseX + 15, mouseY);
    text("Cantidad: " + infoCantidad, mouseX + 15, mouseY + 15);
  }
}

void dibujarLineaInteractiva(float angle, float baseRadius, int cantidad, 
                             int r, int g, int b, String tipo, String year) {
  float len = map(cantidad, 0, 150, 10, 80);
  float x1 = cos(angle) * baseRadius;
  float y1 = sin(angle) * baseRadius;
  float x2 = cos(angle) * (baseRadius + len);
  float y2 = sin(angle) * (baseRadius + len);

// Dibuja la lniea con color y el grosor que quiero
  stroke(r, g, b, 200);
  strokeWeight(5);
  line(x1, y1, x2, y2);

  // Tooltip si el mouse esta cerca
  float mX = mouseX - width / 2;
  float mY = mouseY - height / 2;

// Si el mouse esat cerca del final de la linea, guarda los datos del punto para mostrar el tooltip
  if (dist(mX, mY, x2, y2) < 8) {
    infoYear = year;
    infoTipo = tipo;
    infoCantidad = cantidad;
    mostrarInfo = true;
  }
}
