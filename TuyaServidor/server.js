const express = require('express');
const TuyAPI = require('tuyapi');

const app = express();
app.use(express.json());

// Cambia estos datos por los tuyos:
const device = new TuyAPI({
  id: 'TU_DEVICE_ID',
  key: 'TU_LOCAL_KEY'
});

let connected = false;

// Conectamos al dispositivo
device.find().then(() => {
  return device.connect();
}).then(() => {
  console.log('✅ Conectado al foco');
  connected = true;
}).catch(err => {
  console.error('Error conectando:', err);
});

// Endpoint para encender/apagar
app.post('/power', async (req, res) => {
  const { state } = req.body; // {"state": true} o {"state": false}
  if (!connected) {
    return res.status(500).send('No conectado al dispositivo');
  }
  try {
    await device.set({set: state});
    res.send(`Foco cambiado a ${state ? 'ENCENDIDO' : 'APAGADO'}`);
  } catch (err) {
    res.status(500).send(`Error: ${err}`);
  }
});

// Iniciar el servidor
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`🚀 API escuchando en http://localhost:${PORT}`);
});
