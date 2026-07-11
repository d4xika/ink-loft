import { createRouter, createWebHistory } from "vue-router";
import API from "../helper/api.js";

const AuthenticationView = () => import("../views/AuthenticationView.vue");

const routes = [
  {
    path: "/",
    name: "authentication",
    component: AuthenticationView,
  },
  {
    path: "/home",
    name: "home",
    component: () => import("@/views/home/HomeView.vue"),
  },
  {
    path: "/reads",
    children: [
      {
        path: "/new",
        name: "newRead",
        component: () => import("@/views/reads/read/NewView.vue"),
      },
      {
        path: "/edit/:id",
        name: "editRead",
        component: () => import("@/views/reads/read/EditView.vue"),
      },
      {
        path: "/:id",
        name: "showRead",
        component: () => import("@/views/reads/read/ShowReadView.vue"),
      },
      {
        path: "/want_to_read",
        name: "wantToRead",
        component: () => import("@/views/reads/lists/WantToReadView.vue"),
      },
      {
        path: "/have_read",
        name: "haveRead",
        component: () => import("@/views/reads/lists/HaveReadView.vue"),
      },
      {
        path: "/dropped",
        name: "dropped",
        component: () => import("@/views/reads/lists/DroppedView.vue"),
      },
    ],
  },
  {
    path: "/profile",
    name: "profile",
    component: () => import("@/views/profile/ProfileView.vue"),
  },
  {
    path: "/quotes",
    name: "quotes",
    component: () => import("@/views/quotes/QuotesView.vue"),
  },
];

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition;
    } else {
      return { top: 0 };
    }
  },
});

let isAuthChecked = false;
let isAuthenticated = false;
let invalidCsrfLogoutPromise = null;

const INVALID_CSRF_MARKERS = [
  "InvalidAuthenticityToken",
  "Can't verify CSRF token authenticity",
];

function matchesInvalidCsrfMarker(value) {
  if (!value) {
    return false;
  }

  const content =
    typeof value === "string" ? value : JSON.stringify(value);

  return INVALID_CSRF_MARKERS.some((marker) => content.includes(marker));
}

function isInvalidCsrfError(error) {
  if (error?.config?.skipInvalidCsrfHandler) {
    return false;
  }

  if (error?.response?.status !== 422) {
    return false;
  }

  return (
    matchesInvalidCsrfMarker(error.response?.data) ||
    matchesInvalidCsrfMarker(error.response?.request?.responseText) ||
    matchesInvalidCsrfMarker(error.message)
  );
}

export function setAuthStatus(status) {
  isAuthenticated = status;
  if (!status) {
    localStorage.removeItem("user");
    delete API.defaults.headers.common["X-CSRF-Token"];
  }
  isAuthChecked = true;
}

async function logoutAfterInvalidCsrf() {
  if (invalidCsrfLogoutPromise) {
    return invalidCsrfLogoutPromise;
  }

  invalidCsrfLogoutPromise = (async () => {
    try {
      const response = await API.get("/csrf", {
        skipInvalidCsrfHandler: true,
      });
      API.defaults.headers.common["X-CSRF-Token"] = response.data.csrf_token;

      await API.put("users/logout", null, {
        skipInvalidCsrfHandler: true,
      });
    } catch {
      // A failed cleanup request should not keep the user on a broken session.
    } finally {
      setAuthStatus(false);

      if (router.currentRoute.value.name !== "authentication") {
        await router.replace({ name: "authentication" });
      }

      invalidCsrfLogoutPromise = null;
    }
  })();

  return invalidCsrfLogoutPromise;
}

API.interceptors.response.use(
  (response) => response,
  async (error) => {
    if (isInvalidCsrfError(error)) {
      await logoutAfterInvalidCsrf();
    }

    return Promise.reject(error);
  },
);

router.beforeEach(async (to, from, next) => {
  if (!isAuthChecked) {
    try {
      const response = await API.get("users/is_logged_in");
      API.defaults.headers.common["X-CSRF-Token"] = response.data.csrf_token;

      isAuthenticated = response.data.authenticated;
    } catch (error) {
      isAuthenticated = false;
    }
    isAuthChecked = true;
  }

  if (!isAuthenticated) {
    if (to.path !== "/") {
      next("/");
    } else {
      next();
    }
  } else {
    if (to.path === "/") {
      next("/home");
    } else {
      next();
    }
  }
});

export default router;
