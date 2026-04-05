<script setup>
import { computed, ref } from "vue";
import { zodResolver } from "@primevue/forms/resolvers/zod";
import { z } from "zod";
import { REGEX } from "../helper/regex.js";
import API from "../helper/api.js";

const tab = ref("LOGIN");
const tabOptions = ["LOGIN", "REGISTER"];

const user = ref({
  username: "",
  password: "",
  email: "",
  confirm_password: "",
});

const resolver = computed(() => {
  const formAttributes = {
    username: z.string().min(1, { message: "Username is required." }),
    password: z.string().min(1, { message: "Password is required." }),
  };

  if (tab.value === "REGISTER") {
    formAttributes.email = z
      .string()
      .min(1, { message: "Email is required." })
      .regex(REGEX.email, "Invalid email.");
    formAttributes.confirm_password = z
      .string()
      .min(1, { message: "Password is required." });

    return zodResolver(
      z
        .object({ formAttributes })
        .refine((data) => data.password === data.confirm_password, {
          message: "Passwords don't match.",
          path: ["confirm_password"],
        }),
    );
  }

  return zodResolver(z.object({ formAttributes }));
});

function submit({ valid }) {
  console.log(valid);
  if (!valid) {
    return;
  }

  if (tab.value === "LOGIN") {
    API.post("users/login", {
      params: { username: user.value.username, password: user.value.password },
    }).then(
      (response) => {
        console.log(response);
      },
      (error) => {
        console.log(error);
      },
    );
  }
}
</script>

<template>
  <div class="authentication-view-container">
    <h1>Welcome Reader</h1>
    <div class="content">
      <div>Logo</div>
      <ILSelectButton v-model="tab" :options="tabOptions" />
      <Form
        v-slot="$form"
        :initialValues="user"
        :resolver="resolver"
        class="form-container"
      >
        {{ $form }}

        <ILTextInput
          v-if="tab === 'REGISTER'"
          name="email"
          label="Email"
          v-model="user.email"
          type="email"
        />
        <ILTextInput
          name="username"
          label="Username"
          v-model="user.username"
        ></ILTextInput>
        <ILTextInput
          name="password"
          label="Password"
          v-model="user.password"
          type="password"
        />
        <ILTextInput
          v-if="tab === 'REGISTER'"
          name="confirm_password"
          label="Confirm password"
          v-model="user.confirm_password"
          type="password"
        />
        <ILTextButton text="Submit" @click="submit($form)" />
      </Form>
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
    font-size: 2rem;
  }

  .content {
    flex-grow: 1;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    gap: var(--gap-4);

    .form-container {
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      gap: var(--gap-3);
      width: 60vw;
      max-width: 500px;
    }
  }
}
</style>
