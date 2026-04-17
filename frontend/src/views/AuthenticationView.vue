<script setup>
import { computed, ref } from "vue";
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

const schema = computed(() => {
  const baseSchema = z.object({
    username: z.string().min(1, "Username is required."),
    password: z.string().min(1, "Password is required."),
  });

  if (tab.value === "REGISTER") {
    return baseSchema
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
      });
  }

  return baseSchema;
});

const resolver = async ({ values }) => {
  const result = await schema.value.safeParseAsync(values);

  if (result.success) {
    return {
      values: result.data,
      errors: {},
    };
  }

  const errors = {};

  for (const issue of result.error.issues) {
    const path = issue.path.join(".");

    if (!path) {
      continue;
    }

    if (!errors[path]) {
      errors[path] = [];
    }

    errors[path].push(issue);
  }

  return {
    values,
    errors,
  };
};

async function submit(data) {
  if (!data.valid) {
    // TODO: add toasti
    return;
  }

  try {
    const endpoint = tab.value === "LOGIN" ? "users/login" : "users/register";
    const payload =
      tab.value === "LOGIN"
        ? {
            username: data.values.username,
            password: data.values.password,
          }
        : {
            username: data.values.username,
            password: data.values.password,
            email: data.values.email,
          };

    const response = await API.post(endpoint, payload);

    localStorage.setItem("user", JSON.stringify(response.data));
    await router.push({ name: "home" });
    // TODO: add toasti
  } catch (error) {
    console.log(error);

    if (tab.value === "REGISTER" && error.response?.status === 409) {
      // TODO: add toasti
    }
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
