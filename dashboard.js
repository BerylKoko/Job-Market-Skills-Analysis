const roleData = [
  { role: "Business Analyst", value: 67 },
  { role: "Product Management", value: 59 },
  { role: "Data Analyst", value: 45 },
  { role: "Business Intelligence", value: 15 },
  { role: "Product Analyst", value: 2 },
];

const salaryData = [
  { role: "Data Analyst", value: 81640, n: 10 },
  { role: "Business Analyst", value: 91956.8, n: 19 },
  { role: "Business Intelligence", value: 120640, n: 6 },
  { role: "Product Management", value: 174300, n: 23 },
];

const skillData = [
  { name: "SQL", pct: 29.3, count: 55 },
  { name: "Excel", pct: 22.9, count: 43 },
  { name: "Python", pct: 12.2, count: 23 },
  { name: "Tableau", pct: 11.7, count: 22 },
  { name: "Power BI", pct: 10.6, count: 20 },
  { name: "Jira", pct: 8.0, count: 15 },
  { name: "R", pct: 7.4, count: 14 },
  { name: "A/B testing", pct: 2.7, count: 5 },
  { name: "Figma", pct: 2.1, count: 4 },
];

const seniorityData = [
  { label: "Mid-Senior", pct: 43.6 },
  { label: "Missing", pct: 25.5 },
  { label: "Entry", pct: 14.9 },
  { label: "Associate", pct: 10.6 },
  { label: "Director", pct: 4.8 },
  { label: "Internship", pct: 0.5 },
];

function renderRoles() {
  const container = document.querySelector("#roleBars");
  const max = Math.max(...roleData.map((d) => d.value));

  roleData.forEach((item) => {
    const row = document.createElement("div");
    row.className = "role-row";

    row.innerHTML = `
      <span class="role-label">${item.role}</span>
      <div class="role-track">
        <span class="role-fill" style="width:${(item.value / max) * 100}%"></span>
      </div>
      <strong class="role-value">${item.value}</strong>
    `;

    container.appendChild(row);
  });
}

function renderSalary() {
  const container = document.querySelector("#salaryPlot");
  const min = 70000;
  const max = 190000;

  salaryData.forEach((item) => {
    const pct = ((item.value - min) / (max - min)) * 100;
    const row = document.createElement("div");
    row.className = "salary-row";

    row.innerHTML = `
      <span class="salary-label">${item.role}</span>
      <div class="salary-line">
        <i class="salary-dot" style="left:${pct}%"></i>
        <span class="salary-value" style="left:${pct}%">$${Math.round(item.value / 1000)}K</span>
        <small class="salary-n" style="left:${pct}%">n=${item.n}</small>
      </div>
    `;

    container.appendChild(row);
  });

  const axis = document.createElement("div");
  axis.className = "salary-axis";

  [80000, 120000, 160000, 190000].forEach((tick) => {
    const pct = ((tick - min) / (max - min)) * 100;
    const label = document.createElement("span");
    label.className = "salary-tick";
    label.style.left = `${pct}%`;
    label.textContent = `$${Math.round(tick / 1000)}K`;
    axis.appendChild(label);
  });

  container.appendChild(axis);
}

function renderSkills() {
  const container = document.querySelector("#skillRank");

  skillData.forEach((item, index) => {
    const cell = document.createElement("article");
    cell.className = `skill-cell${index === 0 ? " primary" : ""}`;

    cell.innerHTML = `
      <span>${String(index + 1).padStart(2, "0")} · ${item.name}</span>
      <strong>${item.pct.toFixed(1)}%</strong>
      <small>${item.count} postings</small>
    `;

    container.appendChild(cell);
  });
}

function renderLegend() {
  const colors = [
    "#667281",
    "#343c47",
    "#73e0c1",
    "#9fb0b7",
    "#d6c48e",
    "#dfe6e8",
  ];
  const container = document.querySelector("#seniorityLegend");

  seniorityData.forEach((item, index) => {
    const legend = document.createElement("span");
    legend.className = "legend-item";
    legend.innerHTML = `
      <i class="legend-swatch" style="background:${colors[index]}"></i>
      ${item.label} ${item.pct}%
    `;
    container.appendChild(legend);
  });
}

renderRoles();
renderSalary();
renderSkills();
renderLegend();
