<script setup>
import { zodResolver } from "@primevue/forms/resolvers/zod";
import { computed, ref } from "vue";
import { useI18n } from "vue-i18n";
import { useRouter } from "vue-router";
import { z } from "zod";
import API from "../helper/api.js";
import { REGEX } from "../helper/regex.js";
import { setAuthStatus } from "../router/router.js";

const { t } = useI18n();
const router = useRouter();
const { locale } = useI18n();

const tab = ref("LOGIN");
const tabOptions = computed(() => [
  { value: "LOGIN", label: t("authentication.login") },
  { value: "REGISTER", label: t("authentication.register") },
]);

const initUser = {
  username: "",
  password: "",
  email: "",
  confirm_password: "",
};

const resolver = computed(() => {
  const loginSchema = z.object({
    username: z.string().min(1, "Username is required."),
    password: z.string().min(1, "Password is required."),
  });

  if (tab.value === "REGISTER") {
    return zodResolver(
      loginSchema
        .extend({
          email: z
            .string()
            .min(1, "Email is required.")
            .regex(REGEX.email, "Invalid email format."),
          confirm_password: z.string().min(1, "Confirm password is required."),
        })
        .refine((data) => data.password === data.confirm_password, {
          message: "Passwords don't match.",
          path: ["confirm_password"],
        }),
    );
  }

  return zodResolver(loginSchema);
});

async function submit(data) {
  if (!data.valid) {
    // TODO: add toasti
    return;
  }

  API.get("/csrf").then((response) => {
    API.defaults.headers.common["X-CSRF-Token"] = response.data.csrf_token;

    if (tab.value === "LOGIN") {
      API.post("users/login", {
        username: data.values.username,
        password: data.values.password,
      }).then(
        (response) => {
          localStorage.setItem("user", JSON.stringify(response.data));
          locale.value = response.data.language;
          setAuthStatus(true);
          router.push({ name: "home" });
          // TODO: add toasti
        },
        (error) => {
          // TODO: add toasti
        },
      );
    }
    if (tab.value === "REGISTER") {
      API.post("users/register", {
        username: data.values.username,
        password: data.values.password,
        email: data.values.email,
      }).then(
        (response) => {
          localStorage.setItem("user", JSON.stringify(response.data));
          setAuthStatus(true);
          router.push({ name: "home" });
          // TODO: add toasti
        },
        (error) => {
          if (error.status === 409) {
            // TODO: add toasti
          }
        },
      );
    }
  });
}
</script>

<template>
  <div class="authentication-view-container">
    <div class="content">
      <h1>{{ t("authentication.title") }}</h1>

      <div class="auth-card">
        <ILSelectButton
          v-model="tab"
          :options="tabOptions"
          optionLabel="label"
        />
        <Form
          :initialValues="initUser"
          :resolver="resolver"
          class="form-container"
          @submit="submit"
        >
          <TransitionGroup name="list" tag="div" class="form-fields">
            <ILTextInput
              v-if="tab === 'REGISTER'"
              key="email"
              name="email"
              :label="t('authentication.email')"
              type="email"
            />
            <ILTextInput
              key="username"
              name="username"
              :label="t('authentication.username')"
            />
            <ILTextInput
              key="password"
              name="password"
              :label="t('authentication.password')"
              type="password"
            />
            <ILTextInput
              v-if="tab === 'REGISTER'"
              key="confirm_password"
              name="confirm_password"
              :label="t('authentication.confirm_password')"
              type="password"
            />
          </TransitionGroup>

          <ILTextButton :text="t('general.submit')" type="submit" />
        </Form>
      </div>
    </div>
  </div>
</template>

<style scoped lang="scss">
.authentication-view-container {
  display: flex;
  flex-direction: column;
  height: 100dvh;

  h1 {
    margin-top: 2rem;
    margin-left: 1rem;
    flex-grow: 0;
    font-size: 2.5rem;
  }

  .content {
    flex-grow: 1;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    gap: var(--gap-4);

    .auth-card {
      background-color: var(--color-2);
      padding: var(--gap-3);
      border-radius: var(--border-radius-2);
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      gap: var(--gap-4);

      .form-container {
        display: flex;
        flex-direction: column;
        gap: var(--gap-3);
        width: 80vw;
        max-width: 500px;

        .form-fields {
          display: flex;
          flex-direction: column;
          gap: var(--gap-3);
          position: relative;
          overflow: hidden;
          padding: 5px;
          margin: -5px;
        }
      }

      .list-enter-active,
      .list-leave-active {
        transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
      }

      .list-enter-from {
        opacity: 0;
        transform: translateX(30px);
      }

      .list-leave-to {
        opacity: 0;
        transform: translateX(30px);
      }

      .list-enter-active {
        z-index: 1;
      }

      .list-move {
        transition: transform 0.4s ease;
      }
    }
  }
}
</style>
