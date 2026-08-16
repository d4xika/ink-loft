import axios from "axios";

const configuredBaseUrl = import.meta.env.VITE_API_URL || "/api";
const baseURL = /^https?:\/\//i.test(configuredBaseUrl)
  ? configuredBaseUrl
  : `/${configuredBaseUrl.replace(/^\/+/, "")}`;

const API = axios.create({
  baseURL,
  withCredentials: true,
  headers: {
    "Content-Type": "application/json",
  },
});
export default API;
