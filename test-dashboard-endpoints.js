/**
 * Test all dashboard widget API endpoints sequentially.
 * Usage: node test-dashboard-endpoints.js
 * 
 * Tests against:
 *   1. Legacy IIS directly (https://10.200.250.31:30659)
 *   2. DiasRestApi proxy  (http://10.200.250.5:9090)
 */

const https = require('https');
const http = require('http');

// Skip SSL cert validation for legacy IIS
const agent = new https.Agent({ rejectUnauthorized: false });

const LEGACY_BASE = 'https://10.200.250.31:30659';
const PROXY_BASE = 'http://10.200.250.5:9090';

// All unique dashboard widget endpoint + filter combos
const widgets = [
  { id: 'jobGuarantee', endpoint: '/Api/StudentAssigned/GetAll', filters: [{ searchProp: 'JobGuarantee', searchValue: 'True' }] },
  { id: 'studentAssignedQueue', endpoint: '/Api/StudentAssigned/GetAll', filters: [{ searchProp: 'Queue', searchValue: 'True' }] },
  { id: 'egu', endpoint: '/Api/StudentAssigned/GetAll', filters: [{ searchProp: 'EGU', searchValue: 'True' }] },
  { id: 'signupsToday', endpoint: '/Api/Signup/GetSignup', filters: [{ searchProp: 'SignupsToday', searchValue: 'True' }] },
  { id: 'signupTodayStatusEU', endpoint: '/Api/Signup/GetSignup', filters: [{ searchProp: 'SignupTodayStatusEU', searchValue: 'True' }] },
  { id: 'notOkSignups', endpoint: '/Api/Signup/GetSignup', filters: [{ searchProp: 'NotOkSignups', searchValue: 'True' }] },
  { id: 'myNotOkSignups', endpoint: '/Api/Signup/GetSignup', filters: [{ searchProp: 'My_Not_OkSignups', searchValue: 'True' }] },
  { id: 'cancelToday', endpoint: '/Api/Signup/GetSignup', filters: [{ searchProp: 'CancelToday', searchValue: 'True' }] },
  { id: 'missingPayment', endpoint: '/Api/Signup/GetSignup', filters: [{ searchProp: 'SignupMissingPayment', searchValue: 'True' }] },
  { id: 'missingInvoice', endpoint: '/Api/Signup/GetSignup', filters: [{ searchProp: 'SignupMissingInvoice', searchValue: 'True' }] },
  { id: 'accommodation', endpoint: '/Api/Signup/GetSignup', filters: [{ searchProp: 'Accommodation', searchValue: 'True' }] },
  { id: 'mySignups', endpoint: '/Api/Signup/GetSignup', filters: [{ searchProp: 'MySignups', searchValue: 'True' }] },
  { id: 'missingTestResult', endpoint: '/Api/Signup/GetSignup', filters: [{ searchProp: 'SignupMissingTestResult', searchValue: 'True' }] },
  { id: 'sessionNoSignups', endpoint: '/Api/Session/GetAll', filters: [{ searchProp: 'NoSignups', searchValue: 'True' }, { searchProp: 'Showendsession', searchValue: 'true' }] },
  { id: 'missingProtocol', endpoint: '/Api/Session/GetAll', filters: [{ searchProp: 'MissingProtocol', searchValue: 'True' }, { searchProp: 'Showendsession', searchValue: 'true' }] },
  { id: 'missingProtocolWeek', endpoint: '/Api/Session/GetAll', filters: [{ searchProp: 'MissingProtocol', searchValue: 'True' }, { searchProp: 'Showendsession', searchValue: 'true' }] },
  { id: 'mySessions', endpoint: '/Api/Session/GetAll', filters: [{ searchProp: 'MySessions', searchValue: '' }, { searchProp: 'Showendsession', searchValue: 'true' }] },
  { id: 'filledSessions', endpoint: '/Api/Session/GetAll', filters: [{ searchProp: 'MySessions', searchValue: '' }, { searchProp: 'FilledSession', searchValue: '' }, { searchProp: 'Showendsession', searchValue: 'true' }] },
  { id: 'customerHasContract', endpoint: '/Api/Customer/GetAllFilterDTO', filters: [{ searchProp: 'Customer_HasContract', searchValue: 'True' }] },
  { id: 'salesProfitToday', endpoint: '/Api/Signup/GetSignup', filters: [{ searchProp: 'SalesProfitToday', searchValue: 'True' }] },
  { id: 'salesProfitLastThreeMonths', endpoint: '/Api/Signup/GetSignup', filters: [{ searchProp: 'SalesProfitLastThreeMonths', searchValue: 'True' }] },
  { id: 'salesProfitCancelToday', endpoint: '/Api/Signup/GetSignup', filters: [{ searchProp: 'SalesProfitTodayCancel', searchValue: 'True' }] },
  { id: 'testNotBooked', endpoint: '/Api/AssignTest/GetAll', filters: [{ searchProp: 'TestNotBooked', searchValue: 'True' }] },
  { id: 'testNotBookedPolice', endpoint: '/Api/AssignTest/GetAll', filters: [{ searchProp: 'TestNotBookedPolice', searchValue: 'True' }] },
  { id: 'testToday', endpoint: '/Api/AssignTest/GetAll', filters: [{ searchProp: 'TestToday', searchValue: 'True' }] },
  { id: 'testMissingStatus', endpoint: '/Api/AssignTest/GetAll', filters: [{ searchProp: 'TestMissingStatus', searchValue: 'True' }] },
  { id: 'testMissingStatusPolice', endpoint: '/Api/AssignTest/GetAll', filters: [{ searchProp: 'TestMissingStatusPolice', searchValue: 'True' }] },
  { id: 'qualificationExpire', endpoint: '/Api/Qualification/GetAll', filters: [{ searchProp: 'QualificationExpire', searchValue: 'True' }] },
  { id: 'newestDelta', endpoint: '/Api/UMOLog/GetAll', filters: [] },
  { id: 'websiteSignups', endpoint: '/Api/WebsiteSignup/GetAll', filters: [] },
  { id: 'eboksError', endpoint: '/Api/SystemAssignObject/GetAll', filters: [{ searchProp: 'EboksError', searchValue: 'True' }] },
];

function buildFilterDTO(filters) {
  return {
    PageIndex: 0,
    PageSize: 0,
    Orders: [{ By: 'ID', Direction: 'DESC' }],
    Query: filters.map(f => ({
      searchProp: f.searchProp,
      searchValue: f.searchValue,
      SearchOptions: 1,
      selectedOperator: 0,
    })),
    CountRequired: true,
    TableCountRequired: false,
  };
}

function doRequest(baseUrl, path, body, token) {
  return new Promise((resolve) => {
    const url = new URL(path, baseUrl);
    const isHttps = url.protocol === 'https:';
    const lib = isHttps ? https : http;
    const payload = JSON.stringify(body);

    const options = {
      hostname: url.hostname,
      port: url.port,
      path: url.pathname,
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(payload),
        ...(token ? { 'Authorization': `Bearer ${token}` } : {}),
      },
      timeout: 15000,
      ...(isHttps ? { agent } : {}),
    };

    const req = lib.request(options, (res) => {
      let data = '';
      res.on('data', (chunk) => data += chunk);
      res.on('end', () => {
        let parsed = null;
        try { parsed = JSON.parse(data); } catch {}
        resolve({
          status: res.statusCode,
          queryCount: parsed?.QueryCount ?? parsed?.queryCount ?? null,
          error: parsed?.code || parsed?.Message || null,
          raw: data.substring(0, 200),
        });
      });
    });

    req.on('error', (err) => {
      resolve({ status: 'ERR', queryCount: null, error: err.message, raw: '' });
    });

    req.on('timeout', () => {
      req.destroy();
      resolve({ status: 'TIMEOUT', queryCount: null, error: 'timeout', raw: '' });
    });

    req.write(payload);
    req.end();
  });
}

async function getToken() {
  return new Promise((resolve) => {
    const payload = JSON.stringify({ Username: 'A509279', Password: '123456' });
    const options = {
      hostname: '10.200.250.31',
      port: 30659,
      path: '/Api/AccountInternal/Login',
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(payload),
      },
      timeout: 10000,
      agent,
    };

    const req = https.request(options, (res) => {
      let data = '';
      res.on('data', (chunk) => data += chunk);
      res.on('end', () => {
        try {
          const parsed = JSON.parse(data);
          console.log(`Auth: status=${res.statusCode}, token=${parsed.access_token ? 'YES' : 'NO'}`);
          resolve(parsed.access_token || null);
        } catch {
          console.log(`Auth: status=${res.statusCode}, parse error, raw=${data.substring(0, 100)}`);
          resolve(null);
        }
      });
    });

    req.on('error', (err) => {
      console.log(`Auth error: ${err.message}`);
      resolve(null);
    });

    req.write(payload);
    req.end();
  });
}

async function runTests(label, baseUrl, pathPrefix, token) {
  console.log(`\n${'='.repeat(70)}`);
  console.log(`  ${label}`);
  console.log(`  Base: ${baseUrl}${pathPrefix}`);
  console.log(`${'='.repeat(70)}`);

  const results = [];
  for (const w of widgets) {
    const fullPath = pathPrefix + w.endpoint;
    const body = buildFilterDTO(w.filters);
    const res = await doRequest(baseUrl, fullPath, body, token);
    const status = res.status === 200 ? '✅' : '❌';
    const countStr = res.queryCount !== null ? `count=${res.queryCount}` : `err=${res.error || res.raw?.substring(0, 80)}`;
    console.log(`  ${status} ${w.id.padEnd(30)} ${String(res.status).padEnd(6)} ${countStr}`);
    results.push({ id: w.id, endpoint: w.endpoint, ...res });

    // 500ms delay between requests to avoid CB
    await new Promise(r => setTimeout(r, 500));
  }
  return results;
}

async function main() {
  console.log('Getting legacy auth token...');
  const token = await getToken();
  if (!token) {
    console.log('⚠️  Could not get token, proceeding without auth (expect 401s)');
  }

  // Test 1: Direct to legacy IIS
  const legacyResults = await runTests(
    'TEST 1: Direct to Legacy IIS',
    LEGACY_BASE,
    '',
    token,
  );

  // Test 2: Through DiasRestApi proxy
  const proxyResults = await runTests(
    'TEST 2: Through DiasRestApi Proxy',
    PROXY_BASE,
    '/legacy/API',
    token,
  );

  // Summary
  console.log(`\n${'='.repeat(70)}`);
  console.log('  SUMMARY');
  console.log(`${'='.repeat(70)}`);
  console.log(`${'Widget'.padEnd(30)} ${'Legacy'.padEnd(10)} ${'Proxy'.padEnd(10)} ${'Match?'}`);
  console.log('-'.repeat(65));

  let legacyOk = 0, proxyOk = 0;
  for (let i = 0; i < widgets.length; i++) {
    const l = legacyResults[i];
    const p = proxyResults[i];
    const lStatus = l.status === 200 ? '✅ 200' : `❌ ${l.status}`;
    const pStatus = p.status === 200 ? '✅ 200' : `❌ ${p.status}`;
    const match = l.status === p.status ? '✓' : '⚠️';
    console.log(`${widgets[i].id.padEnd(30)} ${lStatus.padEnd(10)} ${pStatus.padEnd(10)} ${match}`);
    if (l.status === 200) legacyOk++;
    if (p.status === 200) proxyOk++;
  }
  console.log('-'.repeat(65));
  console.log(`Total: Legacy ${legacyOk}/${widgets.length} OK, Proxy ${proxyOk}/${widgets.length} OK`);
}

main().catch(console.error);
