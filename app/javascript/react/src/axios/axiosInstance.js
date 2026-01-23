import axios from "axios";

const axiosInstance = axios.create({
  baseURL: "http://127.0.0.1:3000",
  headers: {
    Accept: "application/json"
  },
  withCredentials: true 
});

axiosInstance.interceptors.request.use((config) => {
  const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content;
  if (csrfToken) config.headers["X-CSRF-Token"] = csrfToken;
  return config;
});

export default axiosInstance;
