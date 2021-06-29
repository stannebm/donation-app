import { Box, Button, HStack, VStack } from "@chakra-ui/react";
import axios from "axios";
import * as R from "ramda";
import React from "react";
import { useFieldArray, useForm } from "react-hook-form";
import FormInput from "../elements/form_input";
import FormSelect from "../elements/form_select";
import type { OfferingForm } from "./forms.types";

export default function Donation() {
  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
    control,
  } = useForm<OfferingForm>({
    defaultValues: {
      type: "donation",
      mass_intentions: [],
    },
  });

  const onSubmit = (transferMethod: "fpx" | "cybersource") => (data: OfferingForm) => {
    console.log("SUBMIT:", data);
    const submission = { ...data };
    const submission_payload = {
      offering: { ...submission, reference_no: new Date().getTime() },
    };
    console.log(submission_payload);
    axios
      .post("/api/offerings", submission_payload)
      .then(function({ data }) {
        console.log("POSTED", data);
      })
      .catch(function(error) {
        console.log(error);
      });
  };

  const { fields } = useFieldArray({
    control,
    name: "mass_intentions",
  });

  return (
    <form>
      <HStack mb={3} align="flex-start">
        <FormInput
          label="Name"
          errors={errors}
          {...register("fromWhom", { required: true })}
        />
        <FormInput
          label="Contact H/P"
          errors={errors}
          {...register("contactNumber", { required: true })}
        />
      </HStack>
      <HStack mb={3} align="flex-start">
        <FormInput
          label="Email"
          errors={errors}
          {...register("emailAddress", {
            required: true,
            pattern: {
              value: /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i,
              message: "Invalid email address",
            },
          })}
        />
      </HStack>
      <HStack mb={3} align="flex-start">
        <FormInput
          label="Donation Amount (RM)"
          errors={errors}
          type="number"
          step="0.01"
          {...register("amount", {
            required: true,
          })}
        />
      </HStack>
      {fields.map(
        (item, index): JSX.Element => {
          return (
            <>
              <Box mb={5} p={3} bg="gray.100">
                <VStack>
                  <>
                    <FormSelect
                      label="Intention"
                      options={[
                        "For Minor Basilica St. Anne",
                        "For the Poor or Sick",
                        "Others",
                      ]}
                      bg="white"
                      errors={errors}
                      errorPath={R.path(["offerings", index, "intention"])}
                      defaultValue={item.intention}
                      {...register(`offerings.${index}.intention` as const, {
                        required: true,
                      })}
                    />
                    <FormInput
                      label="Other Intention"
                      errors={errors}
                      errorPath={R.path(["offerings", index, "otherIntention"])}
                      defaultValue={item.otherIntention}
                      {...register(
                        `offerings.${index}.otherIntention` as const,
                        {
                          required: false,
                        },
                      )}
                    />
                  </>
                </VStack>
              </Box>
            </>
          );
        },
      )}

      <HStack>
        <Button colorScheme="teal" isLoading={isSubmitting} onClick={(e) => {
          handleSubmit(onSubmit("fpx"))()
          e.preventDefault()
        }}>
          Online Banking
        </Button>

        <Button colorScheme="teal" isLoading={isSubmitting} onClick={(e) => {
          handleSubmit(onSubmit("cybersource"))()
          e.preventDefault()
        }}>
          Credit/Debit Card
        </Button>
      </HStack>
    </form>
  );
}
