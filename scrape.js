const fs = require('fs');
const puppeteer = require('puppeteer');
const { execSync } = require('child_process');

const url = process.env.SCRAPE_URL;

if (!url) {
  console.error("Error: SCRAPE_URL environment variable not provided.");
  process.exit(1);
}

// Try to find chromium path dynamically
let chromiumPath = '/usr/bin/chromium-browser';
try {
  chromiumPath = execSync('which chromium || which chromium-browser').toString().trim();
} catch (err) {
  console.error("Chromium not found.");
  process.exit(1);
}

(async () => {
  const browser = await puppeteer.launch({
    headless: true,
    args: ['--no-sandbox', '--disable-setuid-sandbox'],
    executablePath: chromiumPath
  });

  const page = await browser.newPage();
  await page.goto(url, { waitUntil: 'domcontentloaded' });

  const data = await page.evaluate(() => ({
    title: document.title,
    heading: document.querySelector('h1')?.innerText || 'No <h1> found'
  }));

  fs.writeFileSync('scraped_data.json', JSON.stringify(data, null, 2));
  await browser.close();
})();
