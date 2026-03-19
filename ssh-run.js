// Quick SSH helper — usage: node ssh-run.js "command to run on remote"
const { Client } = require('ssh2');
const cmd = process.argv.slice(2).join(' ');
if (!cmd) { console.error('Usage: node ssh-run.js "command"'); process.exit(1); }

const conn = new Client();
conn.on('ready', () => {
  conn.exec(cmd, (err, stream) => {
    if (err) { console.error(err); process.exit(1); }
    stream.on('close', (code) => { conn.end(); process.exit(code || 0); });
    stream.on('data', (d) => process.stdout.write(d));
    stream.stderr.on('data', (d) => process.stderr.write(d));
  });
}).on('error', (err) => {
  console.error('SSH error:', err.message);
  process.exit(1);
}).connect({
  host: '10.200.250.5',
  port: 22,
  username: 'dekra',
  password: '5Civic#Cheetah',
  readyTimeout: 10000,
});
