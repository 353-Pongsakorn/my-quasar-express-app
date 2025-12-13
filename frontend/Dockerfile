# --- STAGE 1: BUILD STAGE ---
# ใช้ Node.js เวอร์ชัน 20 (Alpine เพื่อให้ Image เล็ก) เป็นสภาพแวดล้อมในการ Build
FROM node:20-alpine AS builder

# ตั้งค่า Working Directory ภายใน Container
WORKDIR /app

# คัดลอกไฟล์ package.json และ package-lock.json เพื่อติดตั้ง Dependencies
# การแยกขั้นตอนนี้ช่วยให้ Docker สามารถใช้ Cache ได้ หากไม่มีการเปลี่ยนแปลงใน Dependencies
COPY package*.json ./

# ติดตั้ง Dependencies
# ใช้ 'npm ci' สำหรับการติดตั้งที่เสถียรในสภาพแวดล้อม CI/CD
# --legacy-peer-deps อาจจำเป็นหากมีปัญหาเรื่อง Peer Dependencies
RUN npm ci --legacy-peer-deps

# คัดลอก Source Code ทั้งหมด
COPY . .

# สั่ง Build Quasar Application ในโหมด SPA (Single Page Application)
# Quasar จะสร้างไฟล์ Static ที่พร้อมใช้งานในโฟลเดอร์ /app/dist/spa
RUN npm run build


# --- STAGE 2: PRODUCTION STAGE ---
# ใช้ Nginx เวอร์ชันล่าสุด (Alpine เพื่อให้ Image เล็กมาก) เพื่อเป็น Web Server
FROM nginx:1.27-alpine

# [Optional] หากต้องการตั้งค่า Nginx พิเศษ เช่น Custom Redirects หรือ Caching Headers
# คุณอาจต้องสร้างไฟล์ nginx.conf แล้ว COPY มาทับไฟล์ Default ของ Nginx
# ตัวอย่าง: COPY nginx.conf /etc/nginx/conf.d/default.conf

# คัดลอกไฟล์ Static ที่ Build เสร็จแล้วจาก Stage 1 (builder)
# โดยคัดลอกจาก /app/dist/spa ไปยังโฟลเดอร์ Default ของ Nginx
COPY --from=builder /app/dist/spa /usr/share/nginx/html

# Copy custom Nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# กำหนด Port ที่ Container นี้จะเปิดรับการเชื่อมต่อ (Port 80 คือ Default ของ HTTP)
EXPOSE 80

# คำสั่งเริ่มต้นเมื่อ Container ถูกรัน
# สั่งให้ Nginx ทำงานในโหมด foreground เพื่อให้ Container ยังคงทำงานอยู่
CMD ["nginx", "-g", "daemon off;"]