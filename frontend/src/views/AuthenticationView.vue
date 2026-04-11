<script setup>
import { computed, ref } from "vue";
import { zodResolver } from "@primevue/forms/resolvers/zod";
import { z } from "zod";
import { REGEX } from "../helper/regex.js";
import API from "../helper/api.js";
import { useRouter } from "vue-router";

const router = useRouter();

const tab = ref("LOGIN");
const tabOptions = ["LOGIN", "REGISTER"];

const user = {
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

function submit(data) {
  console.log(data);
  if (!data.valid) {
    // TODO: add toasti
    return;
  }

  if (tab.value === "LOGIN") {
    API.post("users/login", {
      username: data.values.username,
      password: data.values.password,
    }).then(
      (response) => {
        localStorage.setItem("user", JSON.stringify(response.data));
        router.push({ name: "home" });
        // TODO: add toasti
      },
      (error) => {
        console.log(error);
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
        // TODO: add toasti
      },
      (error) => {
        console.log(error);
        if (error.status === 409) {
          // TODO: add toasti
        }
      },
    );
  }
}
</script>

<template>
  <div class="authentication-view-container">
    <div class="content">
      <h1>Welcome Reader</h1>

      <div class="auth-card">
        <ILSelectButton v-model="tab" :options="tabOptions" />
        <Form
          @submit="submit"
          :initialValues="user"
          :resolver="resolver"
          :key="tab"
          class="form-container"
        >
          <ILTextInput
            v-if="tab === 'REGISTER'"
            name="email"
            label="Email"
            type="email"
          />
          <ILTextInput name="username" label="Username"></ILTextInput>
          <ILTextInput name="password" label="Password" type="password" />
          <ILTextInput
            v-if="tab === 'REGISTER'"
            name="confirm_password"
            label="Confirm password"
            type="password"
          />
          <ILTextButton text="Submit" type="submit" />
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
    gap: var(--gap-5);

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
      }
    }
  }
}
</style>
